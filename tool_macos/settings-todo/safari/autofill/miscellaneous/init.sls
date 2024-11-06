# vim: ft=sls

Safari autofills miscellaneous forms:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillMiscellaneousForms
    - value: True
    - vtype: bool
    - user: {{ user.name }}
