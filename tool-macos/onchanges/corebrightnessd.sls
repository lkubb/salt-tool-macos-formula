corebrightnessd was reloaded:
  cmd.wait:
    - name: killall corebrightnessd
    - watch: []
    - onlyif:
        - pgrep corebrightnessd
