{#-
    Customizes power state of Bluetooth.

    Values:
        - bool [default: true]

    .. note::

        Needs to run as root.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.bluetooth is defined and macos.bluetooth.enabled is defined %}

# Up to Big Sur (?), the key was found in /Library/Preferences/com.apple.Bluetooth
# as ControllerPowerState with vtype int.

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
  # Up to Sierra, the daemon was called blued.
      - bluetoothd was reloaded
{%- endif %}
