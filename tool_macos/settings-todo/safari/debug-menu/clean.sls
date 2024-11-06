# vim: ft=sls

Safari's debug menu is hidden:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: IncludeInternalDebugMenu
    - value: False
    - vtype: bool
    - user: {{ user.name }}
