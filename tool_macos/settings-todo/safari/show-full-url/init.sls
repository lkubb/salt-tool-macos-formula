Safari shows full URL without scheme though:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowFullURLInSmartSearchField
    - value: True
    - vtype: bool
    - user: {{ user.name }}
