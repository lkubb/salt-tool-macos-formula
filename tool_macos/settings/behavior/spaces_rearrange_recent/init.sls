# vim: ft=sls

{#-
    Customizes rearrangement of spaces based on recency.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.spaces_rearrange_recent", "defined") %}

Rearrangement of spaces based on recency is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: mru-spaces
    - value: {{ user.macos.behavior.spaces_rearrange_recent | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
