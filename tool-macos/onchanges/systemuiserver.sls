SystemUIServer was reloaded:
  cmd.wait:
    - name: killall SystemUIServer
    - watch: []
    - onlyif:
        - pgrep SystemUIServer
