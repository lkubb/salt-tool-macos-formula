{#-
    Resets rearrangement of spaces based on recency to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.spaces_rearrange_recent', 'defined') %}

Rearrangement of spaces based on recency is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: mru-spaces
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
