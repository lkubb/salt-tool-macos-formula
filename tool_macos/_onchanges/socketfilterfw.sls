# -*- coding: utf-8 -*-
# vim: ft=sls

socketfilterfw was reloaded:
  cmd.wait:  # noqa: 213
    - name: pkill -HUP socketfilterfw
    - runas: root
    - watch: []
    - onlyif:
        - pgrep socketfilterfw
