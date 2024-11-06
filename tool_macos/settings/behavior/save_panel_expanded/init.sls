# vim: ft=sls

{#-
    Customizes default state of save panel (expanded vs collapsed).

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.save_panel_expanded", "defined") %}

Default state of save panel is managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in NSGlobalDomain
        - NSNavPanelExpandedStateForSaveMode
        - NSNavPanelExpandedStateForSaveMode2
    - value: {{ user.macos.behavior.save_panel_expanded | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
