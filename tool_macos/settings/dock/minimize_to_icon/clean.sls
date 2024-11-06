# vim: ft=sls

{#-
    Resets window minimization behavior to default (separate dock tile).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.minimize_to_icon", "defined") %}

Window minimization behavior is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: minimize-to-application
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
