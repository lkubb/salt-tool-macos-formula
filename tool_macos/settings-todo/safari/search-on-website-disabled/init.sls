Safari does not search on the current website (Quick Website Search):
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebsiteSpecificSearchEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
