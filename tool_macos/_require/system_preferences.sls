System Preferences is not running:
  cmd.run:
    - name: |
        killall "System Preferences"
    - onlyif:
        - pgrep "System Preferences"
