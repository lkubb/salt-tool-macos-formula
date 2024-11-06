# vim: ft=sls

{#- @internal
    Helper for enabling/disabling four finger horizontal swipes.
    This is needed for Swipe Fullscreen gesture.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") %}
{%-   from tpldir ~ "/map.jinja" import status with context %}

{%-   if status is not sameas False %}
Four finger horizontal swipe on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadFourFingerHorizSwipeGesture
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger horizontal swipe on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadFourFingerHorizSwipeGesture
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger horizontal swipe on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.fourFingerHorizSwipeGesture # in Apple Global Domain
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
