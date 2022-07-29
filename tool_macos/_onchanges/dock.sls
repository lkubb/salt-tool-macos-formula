# -*- coding: utf-8 -*-
# vim: ft=sls

Dock was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall Dock
    - watch: []
    - onlyif:
        - pgrep Dock
