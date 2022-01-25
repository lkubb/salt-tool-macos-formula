Safari does not autohide the tab bar:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AlwaysShowTabBar
    - value: True
    - vtype: bool
    - user: {{ user.name }}
