# vim: ft=sls

{#-
    Resets Bluetooth bitpool settings to defaults (audio quality/lags).

    This worked up until Big Sur (macOS 11).

    to reload, kill blued (up to sierra) or bluetoothd

#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.bluetooth is defined and macos.bluetooth.bitpool is defined %}

# higher bitpool = better quality, possibly more interruptions
Bluetooth minimum bitpool is set to custom value:
  macdefaults.write:
    - domain: com.apple.BluetoothAudioAgent
    - name: Apple Bitpool Min (editable)
    - value: {{ macos.bluetooth.bitpool.min }}
    - vtype: int
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - bluetoothd was reloaded
{%- endif %}

Bluetooth minimum bitpool is reset to default value:
  macdefaults.absent:
    - domain: com.apple.BluetoothAudioAgent
    - name: Apple Bitpool Min (editable)
    - user: {{ salt["pillar.get"]("macust:user:username") }}
