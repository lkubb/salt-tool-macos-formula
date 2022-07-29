# -*- coding: utf-8 -*-
# vim: ft=sls

SystemUIServer was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall SystemUIServer
    - watch: []
    - onlyif:
        - pgrep SystemUIServer
