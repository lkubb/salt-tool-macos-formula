# vim: ft=sls

Safari's sidebar is hidden in Top Sites:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowSidebarInTopSites
    - value: False
    - vtype: bool
    - user: {{ user.name }}
