Safari does not autofill passwords:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillPasswords
    - value: False
    - vtype: bool
    - user: {{ user.name }}
