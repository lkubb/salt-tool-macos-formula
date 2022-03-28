adprivacyd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall adprivacyd
    - watch: []
    - onlyif:
        - pgrep adprivacyd
