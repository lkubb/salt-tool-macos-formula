# vim: ft=sls

{#-
    Resets bounce animation in dock (alert on changes/needs attention) to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.animations", "defined") | selectattr("macos.animations.dock_bounce", "defined") %}

Dock bounce animation is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: no-bouncing
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
