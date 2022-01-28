"""
Interface with pmset on MacOS.

"""
import logging
import re

import salt.utils.platform
from salt.exceptions import CommandExecutionError


log = logging.getLogger(__name__)
__virtualname__ = "pmset"


__func_alias__ = {
    "set_": "set",
}


SET_SCOPES = {"all": "-a", "battery": "-b", "ac": "-c", "ups": "-u"}

GET_SCOPES = {
    "battery": "Battery Power",
    "ac": "AC Power",
    "ups": "UPS settings",
    "current": "Currently in use",
    "system": "System-wide power settings",  # mostly DestroyFVKeyOnStandby
}


def __virtual__():
    """
    This only works on MacOS (duh)
    """
    if salt.utils.platform.is_darwin():
        return __virtualname__
    return False


def set_(value, name=None, scope="all"):
    """
    Configures a setting with pmset.

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.set displaysleep 5

        salt '*' pmset.set womp false scope=battery

    value
        Specifies the value to set. See `man pmset` for valid arguments,
        depending on the type of setting. Most are boolean or integers
        that specify a time duration in minutes.
        If value is a dict, it will set multiple keys for the specified
        scope.

    name
        Specifies the setting name. See `man pmset` for valid arguments.
        To dig further, see `pmset -g getters`. If value is a dict,
        this parameter is not needed.

    scope
        The scope to apply the setting to. Valid scopes are:
            battery, ac, ups, all
        Defaults to all.

    """

    if scope not in SET_SCOPES:
        raise CommandExecutionError("pmset: Scope '{}' is invalid.".format(scope))

    if isinstance(value, dict):
        cmd = [SET_SCOPES[scope]] + [x for k, v in value.items() for x in [k, v]]
    elif name:
        cmd = [SET_SCOPES[scope], name, value]
    else:
        raise CommandExecutionError(
            "You need to define the name of a setting to set or pass a dict of name => value mappings."
        )

    _pmset(cmd, needs_root=True)

    return True


def get(name, scope="current"):
    """
    Retrieves a setting value from pmset for a specified scope.
    Defaults to currently in use.

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.get displaysleep

        salt '*' pmset.get displaysleep scope=ac

        salt '*' pmset.get destroyfvkeyonstandby scope=system

    name
        Specifies the setting to retrieve. See `man pmset` for valid
        arguments. To dig further, see `pmset -g getters`.

    scope
        The scope to look up the setting for. Valid scopes are:
            battery, ac, ups, current, system
        Defaults to current.

    """

    if scope not in GET_SCOPES:
        raise CommandExecutionError("pmset: Scope '{}' is invalid.".format(scope))

    getter = "live" if scope in ["current", "system"] else "custom"

    data = _parse(_pmset(["-g", getter]))

    # defaults vary by platform, so return None if nothing was found
    # most of the defaults should be in there anyways
    return data.get(GET_SCOPES[scope], {}).get(name)


def get_all(name):
    """
    Retrieves a setting value from pmset for all scopes where it can
    be found. Returns a dict {scope: value, ...}, where scope is
    element of [battery, ac, ups, system, current].

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.get_all displaysleep

    name
        Specifies the setting to retrieve. See `man pmset` for valid
        arguments. To dig further, see `pmset -g getters`.

    """

    data = {}

    settings = _parse(_pmset(["-g", "custom"]))
    live = _parse(_pmset(["-g", "live"]))

    # both outputs have distinct keys, this merges everything to one
    settings.update(live)

    # merge two dicts, python >= 3.5
    #   settings = {**custom, **live}
    # alternative for v 3.9+:
    #   settings = custom | live

    for scope in GET_SCOPES.keys():
        val = settings.get(GET_SCOPES[scope], {}).get(name)
        # if (val := settings.get(GET_SCOPES[scope], {}).get(name)) is not None:
        if val is not None:
            data.update({scope: val})

    return data


def get_scope(scope="current"):
    """
    Retrieves all setting values for a scope from pmset.
    Defaults to currently in use.

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.get_scope

        salt '*' pmset.get_scope battery

    scope
        The scope to look up the settings for. Valid scopes are:
            battery, ac, ups, current, system
        Defaults to current.

    """

    if scope not in GET_SCOPES:
        raise CommandExecutionError("pmset: Scope '{}' is invalid.".format(scope))

    getter = "live" if scope in ["current", "system"] else "custom"

    data = _parse(_pmset(["-g", getter]))

    return data.get(GET_SCOPES[scope])


def get_capabilities():
    """
    Retrieves capabilities for current scope from pmset.

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.get_capabilities

    No arguments.

    """
    data = _pmset(["-g", "cap"])

    return [x.strip() for x in data.splitlines()]


def restore_defaults():
    """
    Restores pmset power management settings to defaults.

    CLI Example:

    .. code-block:: bash

        salt '*' pmset.restore_defaults

    No arguments.
    """
    out = _pmset(["restoredefaults"], needs_root=True)

    if "Restored Default settings." in out:
        return True
    raise CommandExecutionError(
        "Failed parsing pmset output '{}'. This should not happen, since the command executed without error.".format(
            out
        )
    )


def _pmset(command, needs_root=False):
    user = "root" if needs_root else None

    ret = __salt__["cmd.run_all"](
        "pmset {}".format(" ".join([str(x) for x in command])), user=user
    )

    if ret["retcode"]:
        raise CommandExecutionError(
            "Error calling pmset. Output: \n{}".format(ret["stderr"])
        )

    return ret["stdout"]


def _parse(data):
    parsed = {}
    """ Example Data:
            System-wide power settings:
             DestroyFVKeyOnStandby      0
            Currently in use:
             standby              1
             Sleep On Power Button 1
             hibernatefile        /var/vm/sleepimage
             powernap             1
             disksleep            10
             sleep                1 (sleep prevented by firefox, sharingd, coreaudiod, powerd)
             hibernatemode        3
             ttyskeepawake        1
             displaysleep         2
             tcpkeepalive         1
             powermode            0
    """
    # split newlines if line ends with a colon
    for group in re.split(r"\n(?=.*:\n)", data):
        # header is before colon, data after
        header, data = group.split(":")
        # split into single lines that are not empty without unnecessary whitespace
        lines = [line.strip() for line in data.splitlines() if line]
        # the comment on sleep inside () makes this much more complicated than it had to be
        # matching groups would have been a better match probably (...)
        # split lines into key -> value
        #   1) if no parentheses: on last whitespace
        #   2) if parentheses: on last whitespace that is
        #       - followed by a word/digit plus a space
        #       - and something in between ()
        # and split the value again on (, take the first part and strip it again
        data = {
            k: v.split("(")[0].strip()
            for line in lines
            for k, v in [
                re.split(
                    r"(?=[^\(\)]+$)[\s]+(?=[\S]+$)|(?=.*[\(\)]+)[\s]+(?=[\w\d]\s\(.*[\)])",
                    line,
                    maxsplit=1,
                )
            ]
        }
        parsed[header] = data
    return parsed
