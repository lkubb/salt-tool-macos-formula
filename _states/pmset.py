"""
Manage power configuration values with pmset on MacOS.

"""


import logging

import salt.utils.platform
from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)

__virtualname__ = "pmset"

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


def set_(name, value, scope="all"):
    """
    Makes sure a pmset setting has a specific value for the specified scope.
    Defaults to all scopes.

    name
        Specifies the setting name. See `man pmset` for valid arguments.
        To dig further, see `pmset -g getters`. Not considered if you specify
        a mapping of name => value in value.

    value
        Specifies the value to set. See `man pmset` for valid arguments,
        depending on the type of setting. Most are boolean or integers
        that specify a time duration in minutes.
        If value is a dict (name => value mapping), it will set multiple
        keys for the specified scope.

    scope
        The scope to apply the setting to. Valid scopes are:
            battery, ac, ups, all
        Defaults to all.

    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}
    change = {}

    try:
        if not isinstance(value, dict):
            value = {name: value}

        for set_name, set_value in value.items():
            if "all" == scope:
                current = __salt__["pmset.get_all"](set_name)
            else:
                current = {scope: __salt__["pmset.get"](set_name, scope)}

            # @TODO this only changes values that are reported as supported,
            # not everything that was specified. warn about that
            for cur_scope, cur_value in current.items():
                if not isinstance(change.get(cur_scope), list):
                    change[cur_scope] = []

                if str(cur_value) != str(set_value):
                    change[cur_scope].append(set_name)

        if not [x for y in change.values() for x in y]:
            ret["comment"] = "All values are already set as specified."
            return ret

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Power management settings would have been updated."
        else:
            __salt__["pmset.set"](value, None, scope)
            ret["comment"] = "Power management settings have been updated."

        ret["changes"] = change

    except CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
