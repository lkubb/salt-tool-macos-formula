Finder was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall Finder
    - watch: []
    - onlyif:
        - pgrep Finder
