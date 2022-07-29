# -*- coding: utf-8 -*-
# vim: ft=sls

coreaudiod was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall coreaudiod
    - watch: []
    - onlyif:
        - pgrep coreaudiod
