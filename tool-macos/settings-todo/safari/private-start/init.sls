include:
  - ..session-restored.clean

Safari starts with a new private window:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: OpenPrivateWindowWhenNotRestoringSessionAtLaunch
    - value: True
    - vtype: bool
    - user: {{ user.name }}
