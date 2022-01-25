Safari prints headers and footers:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: PrintHeadersAndFooters
    - value: True
    - vtype: bool
    - user: {{ user.name }}
