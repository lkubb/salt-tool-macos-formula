# vim: ft=sls

Safari blocks (JS) popups:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitJavaScriptCanOpenWindowsAutomatically # legacy
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically
    - value: False
    - vtype: bool
    - user: {{ user.name }}

# WebKitPreferences.javaScriptCanOpenWindowsAutomatically ?
