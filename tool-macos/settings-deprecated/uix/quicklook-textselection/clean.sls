Quicklook does not allow text selection:
  macdefaults.absent:
    - domain: com.apple.LaunchServices
    - name: QLEnableTextSelection
    - user: {{ user.name }}
