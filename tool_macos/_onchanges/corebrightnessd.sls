# -*- coding: utf-8 -*-
# vim: ft=sls

corebrightnessd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall corebrightnessd
    - watch: []
    - onlyif:
        - pgrep corebrightnessd
