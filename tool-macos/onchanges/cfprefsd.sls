cfprefsd was reloaded:
  cmd.wait:
    - name: killall cfprefsd
    - watch: []
    - onlyif:
        - pgrep cfprefsd
