# vim: ft=sls

{#-
    Customizes Rotate touch gesture activation status.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.rotate", "defined") %}

Rotate gesture on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadRotate
    - value: {{ user.macos.touch.rotate | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Rotate gesture on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadRotate
    - value: {{ user.macos.touch.rotate | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Rotate gesture on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.rotateGesture # in Apple Global Domain
    - value: {{ user.macos.touch.rotate | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
