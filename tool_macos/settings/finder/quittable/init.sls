# vim: ft=sls

{#-
    Customizes Finder quittable status (Quit menu item and Cmd + q).

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.quittable", "defined") %}

Finder quittable status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: QuitMenuItem
    - value: {{ user.macos.finder.quittable | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
