Java in Safari is enabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitJavaEnabled
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles
    - value: True
    - vtype: bool
    - user: {{ user.name }}
