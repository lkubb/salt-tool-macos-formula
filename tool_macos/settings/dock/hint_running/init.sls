# vim: ft=sls

{#-
    Customizes dock hints regarding running apps (dot below).

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.hint_running", "defined") %}

Dock hint setting for running apps is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: show-process-indicators
    - value: {{ user.macos.dock.hint_running | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
