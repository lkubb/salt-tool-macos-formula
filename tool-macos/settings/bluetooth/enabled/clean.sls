{#-
    Resets power state of Bluetooth to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.bluetooth is defined and macos.bluetooth.enabled is defined %}

Bluetooth power state is reset to default (enabled):
  macosdefaults.write:
    - domain: /var/root/Library/Preferences/com.apple.BTServer.plist
    - name: defaultPoweredState
    - value: 'on'
    - vtype: string
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}
