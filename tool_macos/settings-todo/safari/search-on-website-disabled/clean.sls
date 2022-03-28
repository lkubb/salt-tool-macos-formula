Safari searches on the current website (Quick Website Search):
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebsiteSpecificSearchEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
