{#-
    Resets window minimize animation to dock to default (genie).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.dock_minimize', 'defined') %}

Dock window minimize animation is reset to default (genie) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: mineffect
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
