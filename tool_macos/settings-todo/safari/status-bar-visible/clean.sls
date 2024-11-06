# vim: ft=sls

Safari does not show the status bar:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowStatusBar
    - value: False
    - vtype: bool
    - user: {{ user.name }}
