{#-
    Customizes Time Machine backup behavior while on battery (default: disabled)

    You might need to reboot after applying.

    Mind that setting this needs Full Disk Access on your terminal emulator application.

    Mind that the setting is about requiring AC power, so the pillar value is inverted.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.timemachine is defined and macos.timemachine.backup_on_battery is defined %}

Time Machine backup behavior while on battery is managed:
  macosdefaults.write:
    - domain: /Library/Preferences/com.apple.TimeMachine
    - name: RequiresACPower
    - value: {{ False == macos.timemachine.backup_on_battery | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
