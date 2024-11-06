# vim: ft=sls

Safari does not restore previous session on launch:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AlwaysRestoreSessionAtLaunch
    - value: False
    - vtype: bool
    - user: {{ user.name }}
