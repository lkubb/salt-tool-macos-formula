{#- @internal
    Helper for enabling/disabling three finger gestures.
    This is needed for App Exposé and Mission Control gestures,
    swiping between pages with three fingers and
    three finger drag.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import status with context %}

Three finger swipe on USB trackpads is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - TrackpadThreeFingerVertSwipeGesture:
            - value: {{ status.vertical | int }}
        - TrackpadThreeFingerHorizSwipeGesture:
            - value: {{ status.horizontal | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Three finger swipe on Bluetooth trackpads is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
        - TrackpadThreeFingerVertSwipeGesture:
            - value: {{ status.vertical | int }}
        - TrackpadThreeFingerHorizSwipeGesture:
            - value: {{ status.horizontal | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Three finger swipe on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - names: # in Apple Global Domain
        - com.apple.trackpad.threeFingerVertSwipeGesture:
            - value: {{ status.vertical | int }}
        - com.apple.trackpad.threeFingerHorizSwipeGesture:
            - value: {{ status.horizontal | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
