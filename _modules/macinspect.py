import objc
from Foundation import NSURL, NSBundle
import LaunchServices

# https://michaellynn.github.io/2015/08/08/learn-you-a-better-pyobjc-bridgesupport-signature/
def schemes_and_handlers():  # -> dict:
    las = {}
    las_path = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework"

    __bundle__ = NSBundle.bundleWithPath_(las_path)
    objc.loadBundleFunctions(__bundle__, las, [("_LSCopySchemesAndHandlerURLs", b"io^@o^@")], skip_undefined=False)

    error, schemes, handlers = las["_LSCopySchemesAndHandlerURLs"](None, None)

    if error > 0:
        raise RuntimeError("Something went wrong querying LaunchServices. Error: {}".format(error))

    return dict(zip(schemes, handlers))


def all_registered_apps():  # -> list[NSURL]:
    urls = LaunchServices._LSCopyAllApplicationURLs(None)

    if not urls:
        raise RuntimeError("Something went wrong querying LaunchServices.")

    return urls


def utis():
    pass
    # seems like _UTCopyDeclaredTypeIdentifiers in Foundation is not available anymore
    # /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -dump
