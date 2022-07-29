# -*- coding: utf-8 -*-
# vim: ft=sls

cfprefsd was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall cfprefsd
    - watch: []
    - onlyif:
        - pgrep cfprefsd
