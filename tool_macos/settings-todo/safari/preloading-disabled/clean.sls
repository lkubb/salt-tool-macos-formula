# vim: ft=sls

Safari preloads top hits:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: PreloadTopHit
    - value: True
    - vtype: bool
    - user: {{ user.name }}
