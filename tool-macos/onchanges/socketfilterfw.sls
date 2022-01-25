socketfilterfw was reloaded:
  cmd.wait:
    - name: pkill -HUP socketfilterfw
    - runas: root
    - watch: []
    - onlyif:
        - pgrep socketfilterfw
