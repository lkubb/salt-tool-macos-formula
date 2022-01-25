Finder was reloaded:
  cmd.wait:
    - name: killall Finder
    - watch: []
    - onlyif:
        - pgrep Finder
