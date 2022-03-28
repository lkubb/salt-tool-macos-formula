Safari does not allow installing extensions:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ExtensionsEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
