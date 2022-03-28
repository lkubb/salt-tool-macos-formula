corebrightnessd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall corebrightnessd
    - watch: []
    - onlyif:
        - pgrep corebrightnessd
