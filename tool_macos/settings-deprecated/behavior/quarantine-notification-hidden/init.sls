# vim: ft=sls

{#-
    Customizes quarantine notification ("Are you sure you want to open this application?").

    Deprecated on Big Sur (https://macos-defaults.com/misc/LSQuarantine.html).
    Might need a reboot to apply.

    Values: bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.quarantine_notification", "defined") %}

Quarantine notification is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.LaunchServices
    - name: LSQuarantine
    - value: {{ user.macos.behavior.quarantine_notification | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
