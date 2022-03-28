{#-
    Resets multidisplay swoosh animation activation status to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.multidisplay_swoosh', 'defined') %}

Multidisplay swoosh animation activation status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: workspaces-swoosh-animation-off
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
