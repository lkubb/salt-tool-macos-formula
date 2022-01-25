Dock was reloaded:
  cmd.wait:
    - name: killall Dock
    - watch: []
    - onlyif:
        - pgrep Dock
