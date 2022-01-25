Disk Utility does not show all devices in sidebar:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: SidebarShowAllDevices
    - value: False
    - vtype: bool
    - user: {{ user.name }}
