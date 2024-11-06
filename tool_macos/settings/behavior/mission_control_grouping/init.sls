# vim: ft=sls

{#-
    Customizes Mission Control window grouping behavior.

    Values:
        - bool [default: true = group windows by application]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.mission_control_grouping", "defined") %}

Mission Control window grouping behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: expose-group-by-app
    - value: {{ user.macos.behavior.mission_control_grouping | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
