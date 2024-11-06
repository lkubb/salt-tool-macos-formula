# vim: ft=sls

{#- @internal
    Helper for enabling/disabling four finger vertical swipes.
    This is needed for App Exposé and Mission Control gestures.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") %}
{%-   from tpldir ~ "/map.jinja" import status with context %}

{%-   if status is not sameas False %}
Four finger vertical swipe on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadFourFingerVertSwipeGesture
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger vertical swipe on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadFourFingerVertSwipeGesture
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger vertical swipe on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.fourFingerVertSwipeGesture # in Apple Global Domain
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%-   endif %}
{%- endfor %}
