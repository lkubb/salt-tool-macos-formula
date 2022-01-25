ControlCenter was reloaded:
  cmd.wait:
    - name: killall ControlCenter
    - watch: []
    - onlyif:
        - pgrep ControlCenter
