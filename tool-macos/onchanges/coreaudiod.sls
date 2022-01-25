coreaudiod was reloaded:
  cmd.wait:
    - name: killall coreaudiod
    - watch: []
    - onlyif:
        - pgrep coreaudiod
