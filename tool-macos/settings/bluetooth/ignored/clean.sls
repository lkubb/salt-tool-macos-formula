{#-
    Removes added bluetooth device MAC from ignore list.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.bluetooth is defined and macos.bluetooth.ignored is defined %}

Ignored Bluetooth devices were removed from list:
  macosdefaults.absent_from:
    - name: IgnoredDevices
    - value: {{ macos.bluetooth.ignored.devices | json }}
    - domain: com.apple.Bluetooth
    # this needs to be run as root since the file is
    # /Library/Preferences/com.apple.Bluetooth.plist
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}
