# vim: ft=sls

{#-
    Resets app startup animation in dock to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.animations", "defined") | selectattr("macos.animations.dock_launch", "defined") %}

Dock app startup animation is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: launchanim
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
