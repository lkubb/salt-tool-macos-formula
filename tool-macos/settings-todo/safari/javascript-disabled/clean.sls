JavaScript in Safari is enabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
