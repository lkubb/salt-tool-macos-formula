# -*- coding: utf-8 -*-
# vim: ft=sls

Messages.app is not running:
  cmd.run:
    - name: |
        pkill -f /System/Applications/Messages.app/Contents/MacOS/Messages
    - onlyif:
        - pgrep -f /System/Applications/Messages.app/Contents/MacOS/Messages
