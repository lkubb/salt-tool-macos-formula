# vim: ft=sls

bluetoothd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall bluetoothd
    - watch: []
    - onlyif:
        - pgrep bluetoothd
