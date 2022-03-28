{#-
    Resets tracking speed to default (1?).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.tracking_speed', 'defined') %}

Tracking speed is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: com.apple.trackpad.scaling
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
