Safari autohides the toolbar in fullscreen mode:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoShowToolbarInFullScreen
    - value: True
    - vtype: bool
    - user: {{ user.name }}
