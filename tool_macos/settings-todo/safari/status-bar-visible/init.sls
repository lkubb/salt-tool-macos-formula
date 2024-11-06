# vim: ft=sls

Safari shows the status bar:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowStatusBar
    - value: True
    - vtype: bool
    - user: {{ user.name }}
