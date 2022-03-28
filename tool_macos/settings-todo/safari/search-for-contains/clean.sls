Make Safari’s search banners default to Starts With:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: FindOnPageMatchesWordStartsOnly
    - value: True
    - vtype: bool
    - user: {{ user.name }}
