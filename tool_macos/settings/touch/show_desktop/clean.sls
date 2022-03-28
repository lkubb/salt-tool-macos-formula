{#-
    Resets Show Desktop touch gesture activation status to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.pinch.clean

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.show_desktop', 'defined') %}

Show Desktop touch gesture activation status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: showDesktopGestureEnabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
