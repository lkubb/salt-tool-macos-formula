# vim: ft=sls

{#-
    Manages Bluetooth bitpool settings (audio quality/lags)

    This worked up until Big Sur (macOS 11).

    There was a whole bunch of settings:
      com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
      com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 80
      com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 80
      com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" 80
      com.apple.BluetoothAudioAgent "Negotiated Bitpool" 80
      com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 80
      com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 80

      Improve sound quality for Bluetooth headphones/headsets @TODO
      defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" 80
      defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" 48
      defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" 40
      defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" 48
      defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" 53
      defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" 48
      defaults write com.apple.BluetoothAudioAgent "Stream - Flush Ring on Packet Drop (editable)" 30
      defaults write com.apple.BluetoothAudioAgent "Stream - Max Outstanding Packets (editable)" 15
      defaults write com.apple.BluetoothAudioAgent "Stream Resume Delay" "0.75"

    To reload, kill blued (up to Sierra) or bluetoothd.

    References:
      https://gist.github.com/dvf/3771e58085568559c429d05ccc339219
      https://www.reddit.com/r/apple/comments/5rfdj6/pro_tip_significantly_improve_bluetooth_audio/
      https://www.reddit.com/r/sony/comments/oc6ebo/wh1000mx4_bt_sweet_spot_on_osx_with_hi_quality/

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

