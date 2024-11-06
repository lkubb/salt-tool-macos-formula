# vim: ft=sls

Safari does not print backgrounds:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - WebKitShouldPrintBackgroundsPreferenceKey
      - com.apple.Safari.ContentPageGroupIdentifier.WebKit2ShouldPrintBackgrounds
    - value: False
    - vtype: bool
    - user: {{ user.name }}
