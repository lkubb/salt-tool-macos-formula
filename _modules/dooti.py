"""
Get and set default handlers for file extensions, UTI and
URL schemes on macOS 12.0+.

"""
import os.path
import logging

try:
    import objc
    import AppKit
    from Foundation import NSURL, NSArray
    from UniformTypeIdentifiers import UTType, UTTagClassFilenameExtension
    LIBS_AVAILABLE=True
except ImportError:
    LIBS_AVAILABLE=False

from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)

__virtualname__ = "dooti"


def __virtual__():
    """
    This only works on MacOS.
    """
    if salt.utils.platform.is_darwin() and 12 >= int(__salt__['grains.get']('osmajorrelease')):
        if LIBS_AVAILABLE:
            return __virtualname__
    return (False, "Dooti only works on MacOS 12 (Monterey) and above and needs pyobj.")


def ext(ext, handler, allow_dynamic=False):
    """
    Sets a default handler for the specified file extension.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.ext csv "Sublime Text"

    ext
        Specifies the file extension to set the default handler for.

    handler
        Specifies the default handler to set. It has to be currently installed
        for this to work. Allowed formats:

            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")

    allow_dynamic
        When the specified UTI is not registered with MacOS, it will generate a
        dynamic UTI. Those are rejected by default. Set this to true to override.
        Defaults to False.
    """
    d = dooti()
    d.set_default_ext(ext, handler, allow_dynamic)


def uti(uti, handler):
    """
    Sets a default handler for the specified UTI.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.uti public.plain-text "Sublime Text"

    uti
        Specifies the UTI to set the default handler for.

    handler
        Specifies the default handler to set. It has to be currently installed
        for this to work. Allowed formats:

            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")
    """
    d = dooti()
    d.set_default_uti(uti, handler)


def scheme(scheme, handler):
    """
    Sets a default handler for the specified URL scheme. Note that this might
    trigger an interactive dialog for the user to accept.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.uti http Firefox

    uti
        Specifies the UTI to set the default handler for.

    handler
        Specifies the default handler to set. It has to be currently installed
        for this to work. Allowed formats:

            * name ("Firefox", "Sublime Text")
            * bundle ID ("org.mozilla.firefox", "com.sublimetext.4")
            * absolute path ("/Applications/Firefox.app", "/Applications/Sublime Text.app")
    """
    d = dooti()
    d.set_default_scheme(scheme, handler)


def get_ext(ext):
    """
    Returns the absolute filesystem path of the
    default handler for the specified file extension.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.get_ext csv

    ext
        Specifies the file extension to get the default handler's absolute path for.
    """
    d = dooti()
    return d.get_default_ext(ext)


def get_scheme(scheme):
    """
    Returns the absolute filesystem path of the
    default handler for the specified URL scheme.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.get_scheme smb

    scheme
        Specifies the URL scheme to get the default handler's absolute path for.
    """
    d = dooti()
    return d.get_default_scheme(scheme)


def get_uti(uti):
    """
    Returns the absolute filesystem path of the
    default handler for the specified UTI.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.get_uti public.plain-text

    uti
        Specifies the UTI to get the default handler's absolute path for.
    """
    d = dooti()
    return d.get_default_uti(uti)


def get_path(app):
    """
    Returns the absolute filesystem path of the app as seen from dooti.

    CLI Example:

    .. code-block:: bash

        salt '*' dooti.get_path Firefox
        salt '*' dooti.get_path com.sublimetext.4

    app
        Specifies the app to get the absolute path for.
    """
    d = dooti()
    path = d.get_app_path(app)
    return path.fileSystemRepresentation().decode()


class ExtHasNoRegisteredUTI(CommandExecutionError):
    pass


class ApplicationNotFound(CommandExecutionError):
    pass


class BundleURLNotFound(ApplicationNotFound):
    pass


class dooti:
    def __init__(self, workspace=None):
        if workspace is None:
            workspace = AppKit.NSWorkspace.sharedWorkspace()

        self.workspace = workspace

    @staticmethod
    def ext_to_utis(ext):
        """
        Returns all UTI associated with specified file extension.
        If the extension is not registered with MacOS, will return
        a dynamic UTI as first and only element.

        :param str ext: file extension to look up associated UTI for
        """
        return UTType.typesWithTag_tagClass_conformingToType_(
            ext, UTTagClassFilenameExtension, objc.nil
        )

    def set_default_uti(self, uti, app):
        """
        Sets a default handler for a specific UTI.

        :param str | UTType uti: UTI to set the default handler for
        :param str app: absolute filesystem path, name or bundle ID of the handler
        """
        if not isinstance(uti, UTType):
            uti = UTType.importedTypeWithIdentifier_(uti)

        path = self.get_app_path(app)

        self.workspace.setDefaultApplicationAtURL_toOpenContentType_completionHandler_(
            path, uti, objc.nil
        )

    def set_default_scheme(self, scheme, app):
        """
        Sets a default handler for a specific URL scheme.

        :param str scheme: URL scheme to set the default handler for
        :param str app: absolute filesystem path, name or bundle ID of the handler
        """

        path = self.get_app_path(app)

        self.workspace.setDefaultApplicationAtURL_toOpenURLsWithScheme_completionHandler_(
            path, scheme, objc.nil
        )

    def set_default_ext(self, ext, app, allow_dynamic=False):
        """
        Sets a default handler for all UTI registered to a file extension.

        :param str ext: file extension to set the default handler for
        :param str app: absolute filesystem path, name or bundle ID of the handler
        :param bool allow_dynamic: whether to allow dynamic UTIs (default False)

        :raises:
            ExtHasNoRegisteredUTI if the file extension is unknown to MacOS and not allowing dynamic UTI
        """
        utis = dooti.ext_to_utis(ext)

        if "dyn." == str(utis[0])[:4] and not allow_dynamic:
            raise ExtHasNoRegisteredUTI(
                "No UTI are registered for file extension '{}'. To force using a dynamic UTI, pass allow_dynamic=True.".format(
                    ext
                )
            )

        for uti in utis:
            self.set_default_uti(uti, app)

    def get_default_uti(self, uti):
        """
        Returns the filesystem path to the default handler for the
        specified UTI.

        :param str uti | UTType: UTI to look up the default handler path for
        """

        if not isinstance(uti, UTType):
            uti = UTType.importedTypeWithIdentifier_(uti)

        handler = self.workspace.URLForApplicationToOpenContentType_(uti)

        if not handler:
            return None

        # name = handler.lastPathComponent()[:-4]

        return handler.fileSystemRepresentation().decode()

    def get_default_ext(self, ext):
        """
        Returns the filesystem path to the default handler for the
        specified file extension.

        :param str ext: filename extension to look up the default handler path for
        """
        utis = dooti.ext_to_utis(ext)

        # assume the handler is the same for all types (sensible?)
        # even if the extension was not registered, utis will still contain
        # a dynamic UTI, so we do not need to check for an empty iterator
        handler = self.workspace.URLForApplicationToOpenContentType_(utis[0])

        if not handler:
            return None

        # name = handler.lastPathComponent()[:-4]

        return handler.fileSystemRepresentation().decode()

    def get_default_scheme(self, scheme):
        """
        Returns the filesystem path to the default handler for the
        specified URL scheme.

        :param str ext: filename extension to look up the default handler path for
        """
        if "file" == scheme:
            raise ValueError("The file:// scheme cannot be looked up.")

        url = NSURL.URLWithString_(scheme + "://nonexistant")

        handler = self.workspace.URLForApplicationToOpenURL_(url)

        if not handler:
            return None

        # name = handler.lastPathComponent()[:-4]

        return handler.fileSystemRepresentation().decode()

    def get_app_path(self, app):
        """
        Returns a URL (filesystem path prefixed with 'file://' scheme) to an
        application specified by name, absolute path or bundle ID.

        :param str app: name, absolute filesystem path or bundle ID to look up the URL for

        :raises:
            ApplicationNotFound: when no matching application was found
        """
        if "/" == app[0]:
            return NSURL.fileURLWithPath_(app)

        try:
            return self.bundle_to_url(app)
        except BundleURLNotFound:
            pass

        try:
            return self.name_to_url(app)
        except ApplicationNotFound:
            raise ApplicationNotFound(
                "Could not find an application matching the description '{}'.".format(
                    app
                )
            )

    def bundle_to_url(self, bundle_id):
        """
        Returns a URL (filesystem path prefixed with 'file://' scheme) to an
        application with the specified bundle ID.

        :param str bundle_id: bundle ID to look up the URL for

        :raises:
            BundleURLNotFound: when no application with specified bundle ID was found
        """
        path = self.workspace.URLForApplicationWithBundleIdentifier_(bundle_id)

        if path is None:
            raise BundleURLNotFound(
                "There is no bundle with the identifier '{}'.".format(bundle_id)
            )

        return path

    def name_to_url(self, app_name):
        """
        Returns a URL (filesystem path prefixed with 'file://' scheme) to an
        application with the specified name.

        :param str app_name: application name to look up the URL for

        :raises:
            ApplicationNotFound: when no application with specified bundle ID was found
        """
        path = self.workspace.fullPathForApplication_(app_name)

        if path is None:
            raise ApplicationNotFound(
                "Could not find an application named '{}'.".format(app_name)
            )

        return NSURL.fileURLWithPath_(path)

    def path_to_url(self, path, skip_check=False):
        """
        Translates an absolute filesystem path to a URL.

        :param str path: absolute filesystem path to translate
        :param bool skip_check: override check if the target exists and is a directory

        :raises:
            ApplicationNotFound: when no application with specified bundle ID was found
        """

        if not skip_check and not os.path.isdir(path):
            raise ApplicationNotFound(
                "Could not find an application in '{}'.".format(path)
            )

        return NSURL.fileURLWithPath_(path)
