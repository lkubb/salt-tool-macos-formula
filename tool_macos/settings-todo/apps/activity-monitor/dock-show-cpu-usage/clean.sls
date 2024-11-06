# vim: ft=sls

Do not visualize CPU usage in Activity Monitor Dock icon:
  macdefaults.absent:
    - domain: com.apple.ActivityMonitor
    - name: IconType
    - user: {{ user.name }}
