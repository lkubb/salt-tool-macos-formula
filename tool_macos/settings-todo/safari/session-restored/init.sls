# vim: ft=sls

Safari restores previous session on launch:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AlwaysRestoreSessionAtLaunch
    - value: True
    - vtype: bool
    - user: {{ user.name }}
