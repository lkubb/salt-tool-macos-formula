Safari's thumbnail cache is disabled for History and Top Sites:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: DebugSnapshotsUpdatePolicy
    - value: 2
    - vtype: int
    - user: {{ user.name }}
