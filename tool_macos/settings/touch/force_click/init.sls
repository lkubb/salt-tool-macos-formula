# vim: ft=sls

{#-
    Customizes Force Click activation status.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.force_click", "defined") %}

Force Click activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - ActuateDetents:
            - value: {{ user.macos.touch.force_click | to_bool | int }}
            - vtype: int
        - ForceSuppressed:
            - value: {{ False == user.macos.touch.force_click | to_bool }}
            - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

