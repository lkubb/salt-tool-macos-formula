# -*- coding: utf-8 -*-
# vim: ft=sls

Mail.app is not running:
  cmd.run:
    - name: |
        pkill -f /System/Applications/Mail.app/Contents/MacOS/Mail
    - onlyif:
        - pgrep -f /System/Applications/Mail.app/Contents/MacOS/Mail
