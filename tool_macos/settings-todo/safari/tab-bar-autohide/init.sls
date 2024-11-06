# vim: ft=sls

Safari autohides the tab bar:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AlwaysShowTabBar
    - value: False
    - vtype: bool
    - user: {{ user.name }}
