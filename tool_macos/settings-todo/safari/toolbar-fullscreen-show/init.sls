# vim: ft=sls

Safari always displays the toolbar in fullscreen mode:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoShowToolbarInFullScreen
    - value: False
    - vtype: bool
    - user: {{ user.name }}
