# vim: ft=sls

Safari's debug menu is shown:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: IncludeInternalDebugMenu
    - value: True
    - vtype: bool
    - user: {{ user.name }}
