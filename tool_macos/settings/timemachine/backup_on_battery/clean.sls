# vim: ft=sls

{#-
    Resets Time Machine backup behavior while on battery to default (disabled)
    You might need to reboot after applying.
    Mind that setting this needs Full Disk Access on your terminal emulator application.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.timemachine is defined and macos.timemachine.backup_on_battery is defined %}

Time Machine backup behavior while on battery is reset to default (disabled):
  macosdefaults.absent:
    - domain: /Library/Preferences/com.apple.TimeMachine
    - name: RequiresACPower
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
