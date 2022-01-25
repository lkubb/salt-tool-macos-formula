"""
Get and set default handlers for file extensions, UTI and
URL schemes on macOS 12.0+.

"""
import logging

from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)

__virtualname__ = "dooti"


def __virtual__():
    """
    This only works on MacOS.
    """
    if salt.utils.platform.is_darwin() and 12 >= int(__salt__['grains.get']('osmajorrelease')):
        return __virtualname__
    return (False, "Dooti only works on MacOS 12 (Monterey) and above.")


def ext(name, handler, allow_dynamic=False):
    """
    Makes sure the default handler for the specified file extension is set as specified.

    name
        Specifies the file extension to assure the default handler for.

    handler
        Specifies the default handler to assure. It has to be currently installed
        for this to work. Allowed formats:
            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")

    allow_dynamic
        When the specified UTI is not registered with MacOS, it will generate a
        dynamic UTI. Those are rejected by default. Set this to true to override.
        Defaults to False.
    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    cur_handler_path = __salt__['dooti.get_ext'](name)

    try:
        new_handler_path = __salt__['dooti.get_path'](handler)

        if cur_handler_path == new_handler_path:
            ret["comment"] = "Default handler for file extension '{}' is already set to application at '{}'".format(name, new_handler_path)
            return ret

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Default handler for file extension '{}' would have been set to application at '{}'.".format(name, new_handler_path)
            ret["changes"][name] = new_handler_path
            return ret

        __salt__['dooti.ext'](name, new_handler_path, allow_dynamic)

        ret["comment"] = "Default handler for file extension '{}' has been set to application at '{}'.".format(name, new_handler_path)
        ret["changes"][name] = new_handler_path

    except CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def uti(name, handler):
    """
    Sets a default handler for the specified UTI.

    name
        Specifies the UTI to set the default handler for.

    handler
        Specifies the default handler to set. It has to be currently installed
        for this to work. Allowed formats:
            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    cur_handler_path = __salt__['dooti.get_uti'](name)

    try:
        new_handler_path = __salt__['dooti.get_path'](handler)

        if cur_handler_path == new_handler_path:
            ret["comment"] = "Default handler for UTI '{}' is already set to application at '{}'".format(name, new_handler_path)
            return ret

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Default handler for UTI '{}' would have been set to application at '{}'.".format(name, new_handler_path)
            ret["changes"][name] = new_handler_path
            return ret

        __salt__['dooti.uti'](name, new_handler_path)

        ret["comment"] = "Default handler for UTI '{}' has been set to application at '{}'.".format(name, new_handler_path)
        ret["changes"][name] = new_handler_path

    except CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def scheme(name, handler):
    """
    Sets a default handler for the specified URL scheme. Note that this might
    trigger an interactive dialog for the user to accept.

    name
        Specifies the scheme to set the default handler for.

    handler
        Specifies the default handler to set. It has to be currently installed
        for this to work. Allowed formats:
            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")
    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    cur_handler_path = __salt__['dooti.get_scheme'](name)

    try:
        new_handler_path = __salt__['dooti.get_path'](handler)

        if cur_handler_path == new_handler_path:
            ret["comment"] = "Default handler for URL scheme '{}' is already set to application at '{}'".format(name, new_handler_path)
            return ret

        if __opts__["test"]:
            ret["result"] = None
            ret["comment"] = "Default handler for URL scheme '{}' would have been set to application at '{}'.".format(name, new_handler_path)
            ret["changes"][name] = new_handler_path
            return ret

        __salt__['dooti.scheme'](name, new_handler_path)

        ret["comment"] = "Default handler for URL scheme '{}' has been set to application at '{}'.".format(name, new_handler_path)
        ret["changes"][name] = new_handler_path

    except CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
