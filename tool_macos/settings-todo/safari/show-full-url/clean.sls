# vim: ft=sls

Safari hides full URL:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowFullURLInSmartSearchField
    - value: False
    - vtype: bool
    - user: {{ user.name }}
