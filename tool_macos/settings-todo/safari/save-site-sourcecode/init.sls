# vim: ft=sls

Safari saves sites as sourcecode instead of webarchive by default:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: SavePanelFileFormat
    - value: 0
    - vtype: int
    - user: {{ user.name }}
