# vim: ft=sls

{#-
    Resets display status of Bluetooth widget in Menu Bar to default (hidden).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.menubar", "defined") | selectattr("macos.menubar.bluetooth", "defined") %}

Display status of Bluetooth widget in Menu Bar is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.controlcenter
    - name: Bluetooth
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
