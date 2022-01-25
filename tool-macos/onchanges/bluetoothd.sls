bluetoothd was reloaded:
  cmd.wait:
    - name: killall bluetoothd
    - watch: []
    - onlyif:
        - pgrep bluetoothd
