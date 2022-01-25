Terminal uses UTF-8 only:
  macdefaults.write:
    - domain: com.apple.terminal
    - name: StringEncodings
    - value: 4
    - vtype: array
    - user: {{ user.name }}
