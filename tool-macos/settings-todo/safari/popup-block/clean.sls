Safari does not block (JS) popups:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitJavaScriptCanOpenWindowsAutomatically
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically
    - value: True
    - vtype: bool
    - user: {{ user.name }}
