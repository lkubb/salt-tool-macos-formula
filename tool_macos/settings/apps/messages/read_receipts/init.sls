# vim: ft=sls

{#-
    Customizes sending read receipts in Messages.app.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.apps", "defined") |
    selectattr("macos.apps.messages", "defined") |
    selectattr("macos.apps.messages.read_receipts", "defined") %}

Read receipts are managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.imagent
    - name: Setting.EnableReadReceipts
    - value: {{ user.macos.apps.messages.read_receipts | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Messages.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
