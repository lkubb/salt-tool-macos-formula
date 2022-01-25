adprivacyd was reloaded:
  cmd.wait:
    - name: killall adprivacyd
    - watch: []
    - onlyif:
        - pgrep adprivacyd
