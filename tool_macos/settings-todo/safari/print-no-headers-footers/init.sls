# vim: ft=sls

Safari does not print headers and footers:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: PrintHeadersAndFooters
    - value: False
    - vtype: bool
    - user: {{ user.name }}
