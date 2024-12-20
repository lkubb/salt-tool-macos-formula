# vim: ft=sls

{#-
    Resets dock tile size and behavior to default (48 / mutable).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.tile_size", "defined") %}

Dock tile size is reset to default (48) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
{%- if user.macos.dock.size.tiles is defined %}
      - tilesize
{%- endif %}
{%- if user.macos.dock.size.immutable is defined %}
      - size-immutable
{%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
