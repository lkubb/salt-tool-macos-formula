# https://assert.cc/posts/maybe-dont-script-macos-prefs/
# https://shadowfacts.net/2021/scrollswitcher/
# https://github.com/gregneagle/psumac2017
# this does not work with salt installed by Homebrew
# https://github.com/Homebrew/homebrew-core/pull/52835#issuecomment-617502578

try:
    import objc
    import CoreFoundation
    import AppKit
    from UniformTypeIdentifiers import UTType, UTTagClassFilenameExtension
    from Foundation import NSURL

    LIBS_AVAILABLE = True
except ImportError:
    LIBS_AVAILABLE = False

import logging

import salt.utils.platform

# from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)


__virtualname__ = "macsettings"


def __virtual__():
    """
    This only works on MacOS (duh)
    """
    if not salt.utils.platform.is_darwin():
        return (False, "This only runs on MacOS.")

    if not LIBS_AVAILABLE:
        return (False, "Failed importing necessary libraries.")

    return __virtualname__


def natural_scroll(enabled):
    pps = _load_pps()
    pps["setSwipeScrollDirection"](enabled is True)
    return True


# example for other touch stuff
# app = 'com.apple.driver.AppleBluetoothMultitouch.trackpad'
# CoreFoundation.CFPreferencesSetAppValue('TrackpadThreeFingerHorizSwipeGesture',
#                                         1,
#                                         app)
# CoreFoundation.CFPreferencesAppSynchronize(app)
# # bs['BSKernelPreferenceChanged'](app)
# # bs['BSKernelPreferenceChanged']('com.apple.AppleMultitouchTrackpad')

# CoreFoundation.CFPreferencesSetValue(
#     'AppleEnableSwipeNavigateWithScrolls',
#     0,
#     CoreFoundation.kCFPreferencesAnyApplication,
#     CoreFoundation.kCFPreferencesCurrentUser,
#     CoreFoundation.kCFPreferencesAnyHost,
# )
# CoreFoundation.CFPreferencesSynchronize(
#     CoreFoundation.kCFPreferencesAnyApplication,
#     CoreFoundation.kCFPreferencesCurrentUser,
#     CoreFoundation.kCFPreferencesAnyHost,
# )

# pps = {}
# pps_bundle = objc.initFrameworkWrapper(
#     'PreferencePanesSupport',
#     '/System/Library/PrivateFrameworks/PreferencePanesSupport.framework',
#     None,
#     pps,
# )
# backend = pps['MTTGestureBackEnd'].sharedInstance()
# backend.setThreeFingerHorizSwipe_(1)

# noti = AppKit.NSNotificationCenter.defaultCenter()
# noti.postNotificationName_object_userInfo_(
#     'AppleEnableSwipeNavigateWithScrollsDidChangeNotification',
#     None,
#     None,
# )
# dnot = AppKit.NSDistributedNotificationCenter.defaultCenter()
# dnot.postNotificationName_object_userInfo_(
#     'AppleEnableSwipeNavigateWithScrollsDidChangeNotification',
#     None,
#     None,
# )


def _load_pps():
    try:
        pps = dict()
        pps_path = "/System/Library/PrivateFrameworks/PreferencePanesSupport.framework"

        # load PreferencePanesSupport classes into pps
        __bundle__ = objc.initFrameworkWrapper(
            "PreferencePanesSupport",
            globals=pps,
            frameworkIdentifier=None,
            frameworkPath=objc.pathForFramework(pps_path),
        )

        # to set natural swipe stuff, we need this global function
        # (setSwipeScrollDirection) from the library.
        # b'iZ' is the Objective C raw signature.
        # i = return type (int), Z = first argument (bool)
        # see objc._C_INT and objc._C_NSBOOL
        # reference:
        # https://pyobjc.readthedocs.io/en/latest/api/module-objc.html#objective-c-type-strings
        objc.loadBundleFunctions(
            __bundle__, pps, [("setSwipeScrollDirection", b"iZ")], skip_undefined=False
        )
    except objc.error:
        log.error("Could not load PreferencePanesSupport.")

    return pps


def _get_noti():
    return AppKit.NSNotificationCenter.defaultCenter()


def _get_dnoti():
    return AppKit.NSDistributedNotificationCenter.defaultCenter()
