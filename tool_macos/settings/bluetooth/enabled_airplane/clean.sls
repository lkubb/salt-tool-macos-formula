{#-
    Resets power state of Bluetooth in Airplane Mode to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.bluetooth is defined and macos.bluetooth.enabled_airplane is defined %}

Bluetooth power state during Airplane Mode is reset to default (enabled):
  macosdefaults.write:
    - domain: /var/root/Library/Preferences/com.apple.BTServer.plist
    - name: defaultAirplaneModePowerState
    - value: 'on'
    - vtype: string
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}
