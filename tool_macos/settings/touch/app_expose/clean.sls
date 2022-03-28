{#-
    Resets App Exposé touch gesture settings to default (enabled).

    Warning: This might reset more than just App Exposé gesture. @TODO
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.three.clean
  - ..multi_helper.four_vertical.clean

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.app_expose', 'defined') %}

App Expose gesture activation state is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: showAppExposeGestureEnabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
