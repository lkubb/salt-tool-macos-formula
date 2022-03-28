# this should work with most other apps as well, e.g. X11-based:
# defaults write org.x.X11 wm_ffm -bool true

Terminal windows can be focused with cursor hovering alone:
  macdefaults.write:
    - domain: com.apple.terminal
    - name: FocusFollowsMouse
    - value: True
    - vtype: bool
    - user: {{ user.name }}
