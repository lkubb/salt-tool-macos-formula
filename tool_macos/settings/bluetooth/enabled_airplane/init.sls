# vim: ft=sls

{#-
    Customizes power state of Bluetooth in Airplane Mode.

    Values:
        - bool [default: true]

    .. note::

        Needs to run as root.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.bluetooth is defined and macos.bluetooth.enabled_airplane is defined %}

Bluetooth power state during Airplane Mode is managed:
  macosdefaults.write:
    - domain: /var/root/Library/Preferences/com.apple.BTServer.plist
    - name: defaultAirplaneModePowerState
    - value: '{{ "on" if macos.bluetooth.enabled_airplane else "off" }}'
    - vtype: string
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}
