cfprefsd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall cfprefsd
    - watch: []
    - onlyif:
        - pgrep cfprefsd
