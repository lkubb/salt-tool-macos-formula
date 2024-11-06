# vim: ft=sls

Safari displays 12 Top Sites in a grid:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: TopSitesGridArrangement
    - value: 1
    - vtype: int
    - user: {{ user.name }}
