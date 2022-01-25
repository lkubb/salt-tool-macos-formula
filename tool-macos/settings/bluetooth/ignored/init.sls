{#-
    Adds/syncs bluetooth device MAC (to) ignore list.

    Note that this might be dysfunctional in Monterey.

    Values:
      devices: list (default: [])
      sync: bool (default: false)
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.bluetooth is defined and macos.bluetooth.ignored is defined %}
  {%- set sync = macos.bluetooth.ignored.get('sync', False) %}

Ignored Bluetooth device list is managed:
  macosdefaults.{{ 'set' if sync else 'extend' }}:
    - name: IgnoredDevices
    - value: {{ macos.bluetooth.ignored.devices | json }}
{%- if sync %}
    - vtype: array
{%- endif %}
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
