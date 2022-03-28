JavaScript in Safari is disabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled
      - WebKitJavaScriptEnabled # legacy
    - value: False
    - vtype: bool
    - user: {{ user.name }}
