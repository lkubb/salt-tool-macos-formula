# -*- coding: utf-8 -*-
# vim: ft=sls

System Preferences is not running:
  cmd.run:
    - name: |
        killall "System Preferences"
    - onlyif:
        - pgrep "System Preferences"
