Set time zome automatically using current location:
  macdefaults.write:
    - domain: /Library/Preferences/com.apple.timezone.auto.plist
    - name: Active
    - value: False
    - vtype: bool
    - user: root
