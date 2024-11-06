# vim: ft=sls

Safari's Developer menu is disabled:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: IncludeDevelopMenu
    - value: False
    - vtype: bool
    - user: {{ user.name }}
