{#- @internal
    Helper for enabling/disabling four/five finger pinch gestures.
    This is needed for Show Desktop and Launchpad gestures.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}
  {%- set u = user.macos.touch %}
  {%- set status = (u.get('show_desktop', False) or u.get('launchpad', False)) %}

Pinch gesture activation status for internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
      - TrackpadFourFingerPinchGesture
      - TrackpadFiveFingerPinchGesture
    - value: {{ 2 if status else 0 | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Pinch gesture activation status for bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
      - TrackpadFourFingerPinchGesture
      - TrackpadFiveFingerPinchGesture
    - value: {{ 2 if status else 0 | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Pinch gesture activation status on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: Apple Global Domain
    - names:
      - com.apple.trackpad.fourFingerPinchSwipeGesture
      - com.apple.trackpad.fiveFingerPinchSwipeGesture
    - value: {{ 2 if status else 0 | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
