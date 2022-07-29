# -*- coding: utf-8 -*-
# vim: ft=sls

ControlCenter was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall ControlCenter
    - watch: []
    - onlyif:
        - pgrep ControlCenter
