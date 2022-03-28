# Safari configuration
## Caveats
Safari is a sandboxed application, and thus it plist file resides in `~/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari.plist`, not `~/Library/Preferences/com.apple.Safari.plist` (anymore). Using the terminal or some other program that has not been granted the `Full Disk Access` privilege in System Preferences > Security & Privacy (eg running `defaults write` in Terminal.app/iTerm.app) to modify those preferences will fail.

## Todo
@TODO check if any of this actually works. in my Catalina setup, I found the following keys that might suggest some changes:
```
    WebKitDeveloperExtrasEnabledPreferenceKey = 1;
    "WebKitPreferences.aggressiveTileRetentionEnabled" = 1;
    "WebKitPreferences.allowsPictureInPictureMediaPlayback" = 1;
    "WebKitPreferences.applePayEnabled" = 1;
    "WebKitPreferences.asynchronousPluginInitializationEnabled" = 1;
    "WebKitPreferences.backspaceKeyNavigationEnabled" = 0;
    "WebKitPreferences.developerExtrasEnabled" = 1;
    "WebKitPreferences.diagnosticLoggingEnabled" = 1;
    "WebKitPreferences.dnsPrefetchingEnabled" = 1;
    "WebKitPreferences.fullScreenEnabled" = 1;
    "WebKitPreferences.hiddenPageDOMTimerThrottlingAutoIncreases" = 1;
    "WebKitPreferences.invisibleMediaAutoplayNotPermitted" = 1;
    "WebKitPreferences.javaEnabled" = 1;
    "WebKitPreferences.javaScriptCanOpenWindowsAutomatically" = 1;
    "WebKitPreferences.mediaDevicesEnabled" = 1;
    "WebKitPreferences.needsStorageAccessFromFileURLsQuirk" = 0;
    "WebKitPreferences.plugInSnapshottingEnabled" = 1;
    "WebKitPreferences.plugInsEnabled" = 1;
    "WebKitPreferences.serviceControlsEnabled" = 1;
    "WebKitPreferences.shouldAllowUserInstalledFonts" = 0;
    "WebKitPreferences.shouldSuppressKeyboardInputDuringProvisionalNavigation" = 1;
    "WebKitPreferences.showsToolTipOverTruncatedText" = 1;
    "WebKitPreferences.telephoneNumberDetectionIsEnabled" = 1;
    "WebKitPreferences.wantsBalancedSetDefersLoadingBehavior" = 1;
    WebKitRespectStandardStyleKeyEquivalents = 1;
```

## References
* https://lapcatsoftware.com/articles/containers.html
