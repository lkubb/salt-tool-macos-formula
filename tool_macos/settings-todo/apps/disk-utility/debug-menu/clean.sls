# vim: ft=sls

Disk Utility - disable debug menu:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: DUDebugMenuEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}

Disk Utility - disable advanced image options:
  macdefaults.write:
    - domain: com.apple.DiskUtility
    - name: advanced-image-options
    - value: False
    - vtype: bool
    - user: {{ user.name }}
