# vim: ft=sls

Safari starts with a new default window (not private):
  macdefaults.write:
    - domain: com.apple.Safari
    - name: OpenPrivateWindowWhenNotRestoringSessionAtLaunch
    - value: False
    - vtype: bool
    - user: {{ user.name }}
