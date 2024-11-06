# vim: ft=sls

Safari saves sites as webarchive by default:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: SavePanelFileFormat
    - value: 1
    - vtype: int
    - user: {{ user.name }}
