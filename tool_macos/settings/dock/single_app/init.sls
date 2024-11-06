# vim: ft=sls

{#-
    Customizes behavior when selecting an app from the dock.

    .. hint:

        When enabled, when launching an app from the dock, all other apps will be hidden. (single application mode)

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.single_app", "defined") %}

Dock behavior regarding selecting an app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: single-app
    - value: {{ user.macos.dock.single_app | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
