# vim: ft=sls

Safari homepage is set to custom URL:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: HomePage
    - value: {{ user.macos.safari.homepage }}
    - vtype: string
    - user: {{ user.name }}
