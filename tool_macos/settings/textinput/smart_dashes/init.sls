# vim: ft=sls

{#-
    Customizes activation of smart dashes --.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.textinput", "defined") | selectattr("macos.textinput.smart_dashes", "defined") %}

Activation of smart dashes is managed for {{ user.name }}:
  macosdefaults.write:
    - name: NSAutomaticDashSubstitutionEnabled
    - value: {{ user.macos.textinput.smart_dashes | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
