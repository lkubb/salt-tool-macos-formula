# vim: ft=sls

{#-
    Resets zoom UI by scrolling with modifier key feature to defaults.
    Mind that setting this needs Full Disk Access on your terminal emulator application.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.zoom_scroll_ui", "defined") %}

Zoom UI by scrolling with modifier key feature is reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.universalaccess
    - names:
        - closeViewScrollWheelToggle
        - closeViewZoomMode
        - closeViewScrollWheelModifiersInt
        - closeViewZoomFocusFollowModeKey
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
