"""
Manage (system) configuration values on MacOS.
==============================================

"""

from base64 import b64encode
import datetime
import logging

import salt.utils.dictdiffer
import salt.utils.platform
from salt.exceptions import CommandExecutionError

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
    return (False, "Only supported on MacOS.")


def write(name, value, vtype="string", domain=None, user=None, host=None, force=False):
    """
    Makes sure a setting inside MacOS defaults is set as specified.
    Works like `defaults write` command.

    name
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

    force
        If the current data type does not match the new one, this state will fail.
        Setting force to True will override that check.

    """

    # tbh this method is covered by macosdefaults.set
    # it's still here mostly for backwards compatibility
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    value = _cast(value, vtype)

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host)

    if current is not None and type(value) != type(current) and not force:
        ret["result"] = False
        ret[
            "comment"
        ] = "Data type mismatch: current value of {}:{} is of type {}, while new one is {}".format(
            domain, name, type(current), type(value)
        )
        return ret

    if type(current) == type(value) and current == value:
        ret["comment"] = "{}:{} is already set to {}.".format(
            domain_formatted, name, value
        )
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "{}:{} would have been set to {}.".format(
            domain_formatted, name, value
        )
    else:
        out = __salt__["macosdefaults.write"](name, value, vtype, domain, user, host)
        if out["retcode"]:
            ret["result"] = False
            ret["comment"] = "Failed to write default. {} {}".format(
                out["stdout"], out["stderr"]
            )
        else:
            ret["changes"]["written"] = "{}:{} was set to {}.".format(
                domain_formatted, name, value
            )
    return ret


def set_(
    name,
    value,
    vtype=None,
    domain=None,
    skeleton=None,
    user=None,
    host=None,
    delimiter=":",
    force=False,
):
    """
    Ensures a value inside a nested dict is set without deleting the rest.
    If one of the nested keys does not exist, provides the possibility to
    initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.
    Works like `/usr/libexec/PlistBuddy -c "Set :some:nested:key value"` command.

    name
        Specifies the nested namespace of the key inside the given domain
        to manage, separated by delimiter (default: colon).
        Example: some:nested:key.

    value
        Specifies the value to ensure the nested key is set to.

    vtype
        Specifies the data type of the value to ensure the presence of. Valid types:
        str[ing], int[eger], bool[ean], date, data, array, dict, literal.
        Defaults to the value as it is passed (ie does not cast at all).
        For array-add/dict-add, better use macosdefaults.update/append/extend.

    domain
        Specifies the domain to manage. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    user
        Specifies the user to manage the setting for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Specifies delimiter for distinct keys. Defaults to colon (:).

    force
        If the current data type does not match the new one, this state will fail.
        Setting force to True will override that check.

    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    value = _cast(value, vtype)

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if current is not None and type(value) != type(current) and not force:
        ret["result"] = False
        ret[
            "comment"
        ] = "Data type mismatch: current value of {}:{} is of type {}, while new one is {}".format(
            domain_formatted, name, type(current), type(value)
        )
        return ret

    if type(current) == type(value) and current == value:
        ret["comment"] = "{}:{} is already set to {}.".format(
            domain_formatted, name, value
        )
        return ret

    # @TODO change detection is incomplete when using skeleton

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "{}:{} would have been set to {}.".format(
            domain_formatted, name, value
        )
        ret["changes"]["set"] = value
    else:
        out = __salt__["macosdefaults.set"](
            name, value, vtype, domain, skeleton, user, host, delimiter
        )
        if out["retcode"]:
            ret["result"] = False
            ret["comment"] = "Failed to write default. {} {}".format(
                out["stdout"], out["stderr"]
            )
        else:
            ret["comment"] = "{}:{} has been set to {}.".format(
                domain_formatted, name, value
            )
            ret["changes"]["set"] = value
    return ret


def update(
    name,
    value,
    skeleton=None,
    domain=None,
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

    name
        Specifies the nested namespace of the target dict inside the given
        domain to update, separated by delimiter (default: colon).
        Example: some:nested:dict.

    value
        Specifies the dict to update the nested dict with.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

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

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if current is None:
        current = {}

    # get changed values. missing keys are only applied in classic update mode, not merge
    changed, changes = _compare_dicts(current, value, merge_mode=merge)

    if not changed:
        ret["comment"] = "{}:{} is already up to date.".format(domain_formatted, name)
        return ret

    # @TODO change detection is incomplete when using skeleton

    if __opts__["test"]:
        ret["status"] = None
        ret["comment"] = "{}:{} would have been changed.".format(domain_formatted, name)
        ret["changes"] = changes  # do not do that? @TODO
    else:
        out = __salt__["macosdefaults.update"](
            name, value, domain, skeleton, merge, merge_lists, user, host, delimiter
        )

        if out["retcode"]:
            ret["comment"] = "Something went wrong updating {}:{}.".format(
                domain_formatted, name
            )
        else:
            ret["changes"] = changes
    return ret


def append(
    name,
    value,
    skeleton=None,
    domain=None,
    user=None,
    host=None,
    delimiter=":",
    force=False,
):
    """
    Appends to a nested list without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.

    name
        Specifies the nested namespace of the target list inside the given
        domain to append to, separated by delimiter (default: colon).
        Example: some:nested:list.

    value
        Specifies the item to append to the nested list.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to append the list for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    force
        Forces the item to be appended, even if it is already present in the list.

    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if current is None:
        current = []

    # this will not work for a list of dicts @TODO
    if value in current and not force:
        ret["comment"] = "Item is already present in list. Use force to append anyways."
        return ret

    # @TODO change detection is incomplete when using skeleton

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "Item {} would have been appended to list in {}:{}".format(
            value, domain_formatted, name
        )
        ret["changes"]["appended"] = value
    else:
        out = __salt__["macosdefaults.append"](
            name, value, domain, skeleton, user, host, delimiter
        )

        if out["retcode"]:
            ret["comment"] = "Something went wrong appending to {}:{}.".format(
                domain_formatted, name
            )
        else:
            ret["changes"]["appended"] = value

    return ret


def extend(
    name,
    value,
    skeleton=None,
    domain=None,
    user=None,
    host=None,
    delimiter=":",
    force=False,
):
    """
    Extends a nested list without deleting the rest. If one of the nested keys
    does not exist, provides the possibility to initialize it with a skeleton.
    This does not use PlistBuddy behind the scenes, but the defaults command. An
    advantage is that the file path to the actual plist does not have to be known.

    name
        Specifies the nested namespace of the target list inside the given
        domain to extend, separated by delimiter (default: colon).
        Example: some:nested:list.

    value
        Specifies the list of items to extend the nested list with.

    skeleton
        If a node in the path has not been initialized before, use this skeleton
        instead of only empty ones (read: defaults to merge current settings with,
        in case a node is empty).

    domain
        Specifies the domain to write to. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to extend the list for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (comparable to vanilla `defaults write` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    force
        Forces the items to be appended, even if they are already present in the list.

    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if current is None:
        current = []

    changes = [x for x in value if x not in current]

    if not changes and not force:
        ret[
            "comment"
        ] = "Items are already present in list. Use force to extend anyways."
        return ret
    elif not changes and force:
        changes = value

    # @TODO change detection is incomplete when using skeleton

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "Items {} would have been appended to list in {}:{}".format(
            changes, domain_formatted, name
        )
        ret["changes"]["appended"] = changes
    else:
        out = __salt__["macosdefaults.append"](
            name, changes, domain, skeleton, user, host, delimiter
        )

        if out["retcode"]:
            ret["comment"] = "Something went wrong appending to {}:{}.".format(
                domain_formatted, name
            )
        else:
            ret["changes"]["appended"] = changes

    return ret


def absent(name, domain=None, user=None, host=None):
    """
    Makes sure a setting is absent from a domain. Works like `defaults delete` command.

    name
        Specifies the key of the given domain to assure the absence for.

    domain
        Specifies the target domain. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to assure the setting absence for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    if not __salt__["macosdefaults.exists"](name, domain, user, host):
        ret["comment"] = "{}:{} is already absent.".format(domain_formatted, name)
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["changes"]["absent"] = "{}:{} would have been deleted".format(
            domain_formatted, name
        )
        return ret

    out = __salt__["macosdefaults.delete"](name, domain, user, host)

    if out["retcode"]:
        ret["comment"] = "Something went wrong deleting {}:{}.".format(
            domain_formatted, name
        )
    else:
        ret["changes"]["absent"] = "{}:{} is now absent.".format(domain_formatted, name)

    return ret


def absent_less(name, domain=None, user=None, host=None, delimiter=":"):
    """
    Makes sure a (nested) setting is absent from a domain, without affecting
    parent dictionaries.

    name
        Specifies the (nested) namespace inside the given domain to assure the absence of.

    domain
        Specifies the domain to assure the namespace absence for. Can be an actual
        domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to assure the setting absence for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None. (comparable to vanilla `defaults delete` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if current is None:
        ret["comment"] = "Specified key {}:{} already does not exist.".format(
            domain_formatted, name
        )
        return ret

    if __opts__["test"]:
        ret["result"] = None
        ret["comment"] = "Item {}:{} would have been deleted.".format(
            domain_formatted, name
        )
        ret["changes"]["removed"] = "{}:{}".format(domain_formatted, name)
    else:
        out = __salt__["macosdefaults.delete_less"](name, domain, user, host, delimiter)
        if out["retcode"]:
            ret["result"] = False
            ret["comment"]("Failed removing key {}:{}.".format(domain_formatted, name))
        else:
            ret["comment"] = "Deleted {}:{}.".format(domain_formatted, name)
            ret["changes"]["removed"] = "{}:{}".format(domain_formatted, name)

    return ret


def absent_from(name, value, domain=None, user=None, host=None, delimiter=":"):
    """
    Makes sure a list of items is not contained in the specified (nested) list
    inside the given domain.

    name
        Specifies the managed list's namespace inside the given domain.

    value
        Specifies the list of items that should be absent from the list.

    domain
        Specifies the domain to manage. Can be an actual domain or a path to a file.
        Defaults to global domain (-g switch = "NSGlobalDomain" / "Apple Global Domain").
        Not implemented: -app switch from defaults command.

    user
        Specifies the user to assure the absence of items for. Defaults to salt process user.

    host
        "current" or hostname. Runs defaults with -currentHost or -host <hostname> switch.
        Defaults to None (vanilla `defaults delete` command).

    delimiter
        Delimiter for distinct keys. Defaults to colon (:).

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    domain_formatted = domain if domain is not None else "NSGlobalDomain"

    current = __salt__["macosdefaults.read_more"](name, domain, user, host, delimiter)

    if not isinstance(current, list):
        ret["result"] = False
        ret["comment"] = "Specified key {}:{} is not an array.".format(
            domain_formatted, name
        )
        return ret

    remove = [x for x in value if x in current]

    if __opts__["test"]:
        ret["result"] = None
        ret[
            "comment"
        ] = "The following values would have been deleted from list '{}:{}': {}".format(
            domain_formatted, name, remove
        )
        ret["changes"]["removed"] = remove
    else:
        out = __salt__["macosdefaults.delete_from"](
            name, remove, domain, user, host, delimiter
        )
        if out["retcode"]:
            ret["result"] = False
            ret["comment"](
                "Failed removing items '{}' from list in {}:{}.".format(
                    remove, domain_formatted, name
                )
            )
        else:
            ret["comment"] = "Deleted '{}' from list in {}:{}.".format(
                remove, domain_formatted, name
            )
            ret["changes"]["removed"] = remove

    return ret


def _compare_dicts(current, new, merge_mode):
    changes = {}
    cumulative = []

    # tell dictdiffer to include newly missing keys if using classic update mode
    diff = PatchedRecursiveDiffer(
        current, new, ignore_missing_keys=merge_mode
    )
    changed = diff.changed()
    added = diff.added()
    removed = diff.removed()

    cumulative += added
    cumulative += changed

    # dictdiffer returns a list of changed keys in parent.child notation
    if not merge_mode:
        cumulative += removed

    changes["added"] = added
    changes["changed"] = changed
    changes["removed"] = removed
    return bool(cumulative), changes


#######################################################################
# all of the following should have been in __utils__,
# it was copied from the execution module @TODO
#######################################################################


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

    # this should have been in __utils__, was copied from the module @TODO
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


class PatchedRecursiveDiffer(salt.utils.dictdiffer.RecursiveDictDiffer):
    def added(self):
        """
        Returns all keys that have been added.

        If the keys are in child dictionaries they will be represented with
        . notation

        This works for added nested dicts as well, where the parent class
        tries to access keys on non-dictionary values. @TODO pull request

        fixes stuff like ``TypeError: 'bool' object is not subscriptable``
        """

        def _added(diffs, prefix):
            keys = []
            for key in diffs.keys():
                if isinstance(diffs[key], dict):
                    if "old" not in diffs[key]:
                        keys.extend(_added(diffs[key], prefix="{}{}.".format(prefix, key)))
                    elif diffs[key]["old"] == self.NONE_VALUE:
                        keys.append("{}{}".format(prefix, key))
            return keys

        return sorted(_added(self._diffs, prefix=""))

    def removed(self):
        """
        Returns all keys that have been removed.

        If the keys are in child dictionaries they will be represented with
        . notation

        This works for removed nested dicts as well, where the parent class
        tries to access keys on non-dictionary values. @TODO pull request

        fixes stuff like ``TypeError: 'bool' object is not subscriptable``
        """

        def _removed(diffs, prefix):
            keys = []
            for key in diffs.keys():
                if isinstance(diffs[key], dict):
                    if "old" not in diffs[key]:
                        keys.extend(
                            _removed(diffs[key], prefix="{}{}.".format(prefix, key))
                        )
                    elif diffs[key]["new"] == self.NONE_VALUE:
                        keys.append("{}{}".format(prefix, key))
            return keys

        return sorted(_removed(self._diffs, prefix=""))
