# vim: ft=sls

Make Safari’s search banners default to Contains instead of Starts With:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: FindOnPageMatchesWordStartsOnly
    - value: False
    - vtype: bool
    - user: {{ user.name }}
