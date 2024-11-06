# vim: ft=sls

Safari does not automatically open downloaded files it deems safe:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoOpenSafeDownloads
    - value: False
    - vtype: bool
    - user: {{ user.name }}
