{#-
    Customizes power state of Bluetooth.

    Up to Sierra, the daemon was called blued.
    Up to Big Sur (?), the key was found in /Library/Preferences/com.apple.Bluetooth
      as ControllerPowerState with vtype int.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.bluetooth is defined and macos.bluetooth.enabled is defined %}

Bluetooth power state is managed:
  macosdefaults.write:
    - domain: /var/root/Library/Preferences/com.apple.BTServer.plist
    - name: defaultPoweredState
    - value: '{{ "on" if macos.bluetooth.enabled else "off" }}'
    - vtype: string
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}
