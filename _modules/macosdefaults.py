# Differences from official Salt execution module macdefaults:
# + adds host parameter to eg run `defaults -currentHost write`
# + adds data encoding in xml (fixes broken functionality regarding composites)
# + adds set/update/append/extend function to properly allow working with nested dicts
# + adds optional domain, defaults to global domain
# + adds some kind of support for data and date types
# + adds literal data type to skip xml encoding

"""
Read/write/delete (system) configuration values on MacOS.

Works with the defaults command and therefore on a higher abstraction
than individual plist files. Still provides the convenience of PlistBuddy
when working with nested values.

"""
import datetime
import logging
import plistlib
import xml.etree.ElementTree as ET
from base64 import b64encode

import salt.utils.platform
from salt.exceptions import CommandExecutionError
from salt.utils.dictupdate import ensure_dict_key
from salt.utils.dictupdate import update as update_dict

log = logging.getLogger(__name__)
__virtualname__ = "macosdefaults"


__func_alias__ = {
    "set_": "set",
}


def __virtual__():
    """
    This only works on MacOS (duh)
    """
    if salt.utils.platform.is_darwin():
        return __virtualname__
    return False


def write(key, value, vtype="string", domain=None, user=None, host=None):
    """
    Writes a setting to MacOS defaults. Works like `defaults write` command.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.write com.apple.finder ShowPathbar True bool
        salt '*' macosdefaults.write NSGlobalDomain AppleInterfaceStyle Dark
        salt '*' macosdefaults.write com.apple.trackpad.scrollBehavior 2 int host=current

    key
        Specifies the key inside the given domain to write to.

    value
        Specifies the value to write.

    vtype
        Specifies the data type of the value to write. Valid types:
        str[ing], int[eger], bool[ean], date, data, array, dict, literal.
        The value will be parsed into a plist fragment (unless literal is chosen).
        Defaults to string.
        For array-add/dict-add, better use macosdefaults.update/append/extend.

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to write the setting for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults write` command).
    """
    cmd = _cmd_prefix("write", domain, key, host)
    cmd.append('"{}"'.format(_encode(value, vtype)))
    cmd = " ".join(cmd)

    return __salt__["cmd.run_all"](cmd, runas=user)


def set_(
    keys,
    value,
    vtype=None,
    domain=None,
    skeleton=None,
    user=None,
    host=None,
    delimiter=":",
):
    """
    Sets a nested value without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.
    Works like `/usr/libexec/PlistBuddy -c "Set :some:nested:key value"` command.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.set DesktopViewSettings:IconViewSettings:arrangeBy grid domain=com.apple.finder

    keys
        Specifies the nested namespace of the key inside the given domain
        to set, separated by delimiter (default: colon).
        Example: some:nested:key.

    value
        Specifies the value to set the nested key to.

    vtype
        Specifies the data type of the value to write. Valid types:
        str[ing], int[eger], bool[ean], date, data, array, dict, literal.
        Defaults to the value as it is passed (ie does not cast at all).
        For array-add/dict-add, better use macosdefaults.update/append/extend.

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    user
        Specifies the user to write the value for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Specifies delimiter for distinct keys. Defaults to colon (:).

    """

    # never initialize dicts/lists in the function definition
    if skeleton is None:
        skeleton = {}

    # ensure value is of the proper type, if defined
    if vtype is not None:
        value = _cast(value, vtype)

    # in case yaml incites its chaos, plist keys are always strings
    keys = str(keys)

    # get complete domain
    current_all = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
        encode_type = "dict"
    else:
        nodes = [keys]
        encode_type = vtype if vtype is not None else "string"

    # the actual defaults key is the first node
    key = nodes.pop(0)

    # this might be used as write replacement, so nodes could be empty
    if nodes:
        last = nodes.pop()

        # if this is nested more than once, ensure skeleton contains all necessary
        # keys (otherwise it would set the empty string key to a dict)
        if nodes:
            # ensure that our default contains all necessary nested dicts
            # (not the first (actual key in domain) and last (will contain value))
            ensure_dict_key(
                skeleton, delimiter.join(nodes), delimiter, ordered_dict=False
            )

        # if the top key is not defined, replace with complete skeleton
        current = current_all.get(key, skeleton)

        # then make sure all the nodes on the way are setup
        target = _ensure_with_skeleton(nodes, current, skeleton)

        # and set the last node to requested value
        target[last] = value
    else:
        current = value

    cmd = _cmd_prefix("write", domain, key, host)
    cmd.append('"{}"'.format(_encode(current, encode_type)))
    cmd = " ".join(cmd)

    return __salt__["cmd.run_all"](cmd, runas=user)


def update(
    keys,
    value,
    domain=None,
    skeleton=None,
    merge=True,
    merge_lists=False,
    user=None,
    host=None,
    delimiter=":",
):
    """
    Updates a nested dict without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.

    Note: This still applies to a single top key.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.update DesktopViewSettings:IconViewSettings \\
          {arrangeBy: grid} skeleton='{IconViewSettings: {iconSize: 64, labelOnBottom: True}}' \\
          com.apple.finder

    keys
        Specifies the nested namespace of the target dict inside the given
        domain to update, separated by delimiter (default: colon).
        Example: some:nested:dict.

    value
        Specifies the dict to update the nested dict with.

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    merge
        Merge nested dictionaries instead of replacing them. Defaults to true.

    merge_lists
        Merge nested lists instead of replacing them. Defaults to false.

    user
        Specifies the user to update the dict for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """

    # never initialize dicts/lists in the function definition
    if skeleton is None:
        skeleton = {}

    # get complete domain
    current_all = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
    else:
        nodes = [keys]

    # the actual defaults key is the first node
    key = nodes.pop(0)

    # ensure that our default contains all necessary keys
    ensure_dict_key(skeleton, delimiter.join(nodes), delimiter, ordered_dict=False)

    current = current_all.get(key, skeleton)

    # the longer I think about it, the more I am convinced
    # this might be a dumb way of merging defaults (skeleton) with
    # current with new @TODO (difference is that existing key => dict will not be touched)
    target = _ensure_with_skeleton(nodes, current, skeleton)

    update_dict(target, value, recursive_update=merge, merge_lists=merge_lists)
    cmd = _cmd_prefix("write", domain, key, host)
    cmd.append('"{}"'.format(_encode(current, "dict")))
    cmd = " ".join(cmd)

    return __salt__["cmd.run_all"](cmd, runas=user)


def append(
    keys, value, domain=None, skeleton=None, user=None, host=None, delimiter=":"
):
    """
    Appends to a nested list without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.append FK_DefaultListViewSettings:columns \\
          {ascending: 1, identifier: coolness, visible: 1, width: 1000} com.apple.finder

    keys
        Specifies the nested namespace of the target list inside the given
        domain to append to, separated by delimiter (default: colon).
        Example: some:nested:list.

    value
        Specifies the item to append to the nested list.

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    user
        Specifies the user to append the list for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """

    # never initialize dicts/lists in the function definition
    if skeleton is None:
        skeleton = {}

    current_all = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
    else:
        nodes = [keys]

    # the actual defaults key is the first node
    key = nodes.pop(0)

    # ensure our default contains all necessary keys
    _ensure_last(nodes.copy(), skeleton, [])

    # get current data
    current = current_all.get(key, skeleton)

    # ensure our target is initialized and of type list,
    # possibly with the help of skeleton
    target = _ensure_with_skeleton(nodes, current, skeleton, list)

    target.append(value)

    cmd = _cmd_prefix("write", domain, key, host)
    cmd.append('"{}"'.format(_encode(current, "dict")))
    cmd = " ".join(cmd)

    return __salt__["cmd.run_all"](cmd, runas=user)


def extend(
    keys, value, domain=None, skeleton=None, user=None, host=None, delimiter=":"
):
    """
    Extends a nested list without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.extend FK_DefaultListViewSettings:columns \\
          [{ascending: 1, identifier: coolness, visible: 1, width: 1000}, \\
          {ascending: 1, identifier: weirdness, visible: 1, width: 1337}] com.apple.finder

    keys
        Specifies the nested namespace of the target list inside the given
        domain to extend, separated by delimiter (default: colon).
        Example: some:nested:list.

    value
        Specifies the list of items to extend the nested list with.

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    user
        Specifies the user to extend the list for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """

    # never initialize dicts/lists in the function definition
    if skeleton is None:
        skeleton = {}

    current_all = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
    else:
        nodes = [keys]

    # the actual defaults key is the first node
    key = nodes.pop(0)

    # ensure our default contains all necessary keys
    _ensure_last(nodes.copy(), skeleton, [])

    # get current data
    current = current_all.get(key, skeleton)

    # ensure our target is initialized and of type list,
    # possibly with the help of skeleton
    target = _ensure_with_skeleton(nodes, current, skeleton, list)

    target.extend(value)

    cmd = _cmd_prefix("write", domain, key, host)
    cmd.append('"{}"'.format(_encode(current, "dict")))
    cmd = " ".join(cmd)

    return __salt__["cmd.run_all"](cmd, runas=user)


def read(key, domain=None, user=None, host=None):
    """
    Reads a setting from MacOS defaults. Works like `defaults read` command.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.read ShowPathbar com.apple.finder
        salt '*' macosdefaults.read AppleInterfaceStyle
        salt '*' macosdefaults.read com.apple.trackpad.scrollBehavior "Apple Global Domain" host=current

    key
        Specifies the key of the given domain to read from.

    domain
        Specifies the domain to read from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to read the settings as. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults read` command).

    """
    cmd = " ".join(_cmd_prefix("read", domain, key, host))

    return __salt__["cmd.run_stdout"](cmd, runas=user)


def read_all(domain=None, user=None, host=None):
    """
    Reads all settings inside a domain. Works like `defaults export` command,
    but returns parsed python data.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.read_all com.apple.finder
        salt '*' macosdefaults.read_all NSGlobalDomain
        salt '*' macosdefaults.read_all "Apple Global Domain" host=current

    domain
        Specifies the domain to read from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to read the settings as. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults export` command).

    """

    cmd = _cmd_prefix("export", domain, None, host)
    cmd.append("-")
    cmd = " ".join(cmd)

    return _parse(__salt__["cmd.run_stdout"](cmd, runas=user))


def read_more(keys, domain=None, user=None, host=None, delimiter=":"):
    """
    Reads a possibly nested setting from MacOS defaults. Returns data in the
    correct python data type (not OpenSTEP legacy formatted string).

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.read_more DesktopViewSettings:IconViewSettings:arrangeBy com.apple.finder

    key
        Specifies the (nested) namespace of the given domain to read from.

    domain
        Specifies the domain to read from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to read the settings as. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults read` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """

    # in case yaml incites its chaos, plist keys are always strings
    keys = str(keys)

    data = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
    else:
        nodes = [keys]

    ptr = data

    try:
        for each in nodes:
            ptr = ptr[each]
    except KeyError:
        return None
    return ptr


def delete(key, domain=None, user=None, host=None):
    """
    Deletes a setting from a domain. Works like `defaults delete` command.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.delete ShowPathbar com.apple.finder
        salt '*' macosdefaults.delete "Apple Global Domain" AppleInterfaceStyle
        salt '*' macosdefaults.delete com.apple.trackpad.scrollBehavior host=current

    key
        Specifies the key of the given domain to delete.

    domain
        Specifies the domain to delete from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to delete the setting for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    """
    cmd = " ".join(_cmd_prefix("delete", domain, key, host))

    return __salt__["cmd.run_all"](cmd, runas=user, output_loglevel="debug")


def delete_less(keys, domain=None, user=None, host=None, delimiter=":"):
    """
    Deletes a (nested) setting from a domain.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.delete DesktopViewSettings:IconViewSettings:arrangeBy com.apple.finder

    keys
        Specifies the (nested) namespace of the given domain to delete.

    domain
        Specifies the domain to delete from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to delete the setting for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """
    nodes = keys.split(delimiter)
    key = str(nodes.pop())
    keys = delimiter.join(nodes)

    current = read_more(keys, domain, user, host, delimiter)

    if current is None or not current.get(key):
        raise CommandExecutionError(
            "Specified key {}:{}:{} does not exist.".format(domain, keys, key)
        )

    new = {k: v for k, v in current.items() if not k == key}

    return set_(keys, new, "dict", domain, None, user, host, delimiter)


def delete_from(keys, value, domain=None, user=None, host=None, delimiter=":"):
    """
    Deletes items from a (nested) list inside a domain.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.delete_from IgnoredDevices ["MAC 1", "MAC 2"] com.apple.Bluetooth

    keys
        Specifies the (nested) namespace of the given domain to delete from.

    value
        Specifies the list of items that should be removed from the list.

    domain
        Specifies the domain to delete from. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to delete the items for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """
    current = read_more(keys, domain, user, host, delimiter)

    if not isinstance(current, list):
        raise CommandExecutionError(
            "Specified key {}:{} is not an array.".format(domain, keys)
        )

    for x in value:
        if x not in current:
            raise CommandExecutionError(
                "Specified item {} is not an element.".format(x)
            )

    new = [x for x in current if x not in value]

    return set_(keys, new, "array", domain, None, user, host, delimiter)


def exists(keys, domain=None, user=None, host=None, delimiter=":"):
    """
    Checks if a (nested) setting was set inside a domain.

    CLI Example:

    .. code-block:: bash

        salt '*' macosdefaults.exists DesktopViewSettings:IconViewSettings:arrangeBy com.apple.finder

    key
        Specifies the (nested) key of the given domain to check.

    domain
        Specifies the domain to check. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to check the setting for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """
    data = read_all(domain, user, host)

    if delimiter in keys:
        nodes = keys.split(delimiter)
    else:
        nodes = [keys]

    ptr = data

    try:
        for each in nodes:
            ptr = ptr[each]
    except KeyError:
        return False
    return True


def _cmd_prefix(action, domain=None, key=None, host=None):
    cmd = ["defaults"]

    if "current" == host:
        cmd.append("-currentHost")
    elif host:
        cmd.extend(["-host", host])

    cmd.append(action)

    if domain is None:
        cmd.append("-g")
    else:
        cmd.append('"{}"'.format(domain))

    if key:
        cmd.append('"{}"'.format(key))

    return cmd


def _cast(data, vtype):
    if vtype in ["str", "string"]:
        return str(data)
    if vtype in ["int", "integer"]:
        return int(data)
    if vtype in ["bool", "boolean"]:
        return _encode_bool(data, actual_bool=True)
    if vtype in ["float", "real"]:
        return float(data)
    if "data" == vtype:
        return str(_encode_data(data))
    if "date" == vtype:
        return str(_encode_date(data))
    if vtype in ["dict", "dictionary"]:
        return dict(data)
    if vtype in ["array", "list"]:
        return list(data)
    if "literal" == vtype:
        return data


def _ensure_last(nodes, data, last):
    ptr = data

    while nodes:
        key = str(nodes.pop(0))
        if nodes and (key not in ptr or not isinstance(ptr[key], dict)):
            ptr[key] = {}
        elif not nodes and (key not in ptr or not isinstance(ptr[key], type(last))):
            ptr.update({key: last})
        ptr = ptr[key]


def _ensure_with_skeleton(nodes, current, skeleton, last=dict):
    # the longer I think about it, the more I am convinced
    # this is a dumb way of merging defaults (skeleton) with
    # current with new @TODO
    if last is None:
        last = dict
    # to iterate over both dicts, set pointers
    cur_pointer = current
    skel_pointer = skeleton

    while nodes:
        cur_key = str(nodes.pop(0))
        if (
            cur_key not in cur_pointer
            or (nodes and not isinstance(cur_pointer[cur_key], dict))
            or (not nodes and not isinstance(cur_pointer[cur_key], last))
        ):
            cur_pointer[cur_key] = skel_pointer[cur_key]

        cur_pointer = cur_pointer[cur_key]
        skel_pointer = skel_pointer[cur_key]

    return cur_pointer


def _parse(plist):
    return plistlib.loads(plist.encode(), fmt=plistlib.FMT_XML)


def _encode(data, vtype):
    if vtype in ["str", "string"]:
        return "<string>{}</string>".format(data)
    if vtype in ["int", "integer"]:
        return "<integer>{}</integer>".format(data)
    if vtype in ["bool", "boolean"]:
        return "<{}/>".format(_encode_bool(data))
    if vtype in ["float", "real"]:
        return "<real>{}</real>".format(data)
    if "data" == vtype:
        return "<data>{}</data>".format(_encode_data(data))
    if "date" == vtype:
        return "<date>{}</date>".format(_encode_date(data))
    if vtype in ["dict", "array", "list"]:
        return _encode_composite(data)
    if "literal" == vtype:
        return data
    raise CommandExecutionError(
        "Specified data type '{}' is not supported.".format(vtype)
    )


def _encode_bool(data, actual_bool=False):
    true = "true" if not actual_bool else True
    false = "false" if not actual_bool else False

    if isinstance(data, bool):
        if actual_bool:
            return data
        return str(data).lower()
    if isinstance(data, str):
        if data.lower() in ["true", "yes", "1"]:
            return true
        elif data.lower() in ["false", "no", "0"]:
            return false
    if isinstance(data, int):
        if 1 == data:
            return true
        elif 0 == data:
            return false

    raise CommandExecutionError("Could not encode value '{}' as boolean.".format(data))


def _encode_data(data):
    # plist type 'data' is base64-encoded
    if isinstance(data, str):
        data = data.encode()
    return b64encode(data).decode()


def _encode_date(date):
    # date needs to be string in YYYY-MM-DDThh:mm:ssZ format (UTC)
    # example: 2022-01-03T15:12:22Z
    if isinstance(date, datetime.datetime):
        return date.strftime("%Y-%m-%dT%H:%M:%SZ")
    return date


def _encode_composite(data):
    plist = plistlib.dumps(data, fmt=plistlib.FMT_XML, sort_keys=True, skipkeys=False)
    xml = ET.fromstring(plist)
    fragment = ET.tostring(xml[0]).decode()
    return "".join([x.strip() for x in fragment.splitlines()])
