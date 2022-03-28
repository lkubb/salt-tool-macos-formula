Safari does not preload top hits:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: PreloadTopHit
    - value: False
    - vtype: bool
    - user: {{ user.name }}
