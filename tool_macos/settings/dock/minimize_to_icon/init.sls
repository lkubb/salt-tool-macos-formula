# vim: ft=sls

{#-
    Customizes window minimization behavior (to application icon or separate dock tile).

    Values:
        - bool [default: false = minimize to separate dock tile]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.minimize_to_icon", "defined") %}

Window minimization behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: minimize-to-application
    - value: {{ user.macos.dock.minimize_to_icon | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
