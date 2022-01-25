Java in Safari is disabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitJavaEnabled # legacy
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles
    - value: False
    - vtype: bool
    - user: {{ user.name }}

# WebKitPreferences.javaEnabled ?
