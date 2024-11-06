# vim: ft=sls

Safari autofills passwords:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillPasswords
    - value: True
    - vtype: bool
    - user: {{ user.name }}
