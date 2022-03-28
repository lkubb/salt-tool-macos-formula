Safari prints backgrounds:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitShouldPrintBackgroundsPreferenceKey
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2ShouldPrintBackgrounds
    - value: True
    - vtype: bool
    - user: {{ user.name }}
