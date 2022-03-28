# DUDebugMenuEnabled only works until Yosemite.
# https://www.lifewire.com/enable-disk-utilities-debug-menu-2260807

Disk Utility - enable debug menu:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: DUDebugMenuEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}

Disk Utility - enable advanced image options:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: advanced-image-options
    - value: True
    - vtype: bool
    - user: {{ user.name }}
