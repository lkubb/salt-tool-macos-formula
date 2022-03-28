{#-
    Resets availability of persistent dock tiles to default (available).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.persistent_tiles', 'defined') %}

Availability of persistent dock tiles is reset to default (available) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: static-only
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
