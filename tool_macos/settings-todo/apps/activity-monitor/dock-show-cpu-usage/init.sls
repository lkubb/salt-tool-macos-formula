# vim: ft=sls

Visualize CPU usage in Activity Monitor Dock icon:
  macdefaults.write:
    - domain: com.apple.ActivityMonitor
    - name: IconType
    - value: 5
    - vtype: int
    - user: {{ user.name }}
