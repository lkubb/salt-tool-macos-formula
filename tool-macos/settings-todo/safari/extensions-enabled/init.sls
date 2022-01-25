Safari allows installing extensions:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ExtensionsEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
