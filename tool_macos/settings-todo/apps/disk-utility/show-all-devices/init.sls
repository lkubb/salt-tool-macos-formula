# vim: ft=sls

Disk Utility shows all devices in sidebar:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: SidebarShowAllDevices
    - value: True
    - vtype: bool
    - user: {{ user.name }}
