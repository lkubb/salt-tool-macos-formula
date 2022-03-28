{#- @internal
    Resets all three finger gesture mappings to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}

Three finger swipe on USB trackpads is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - TrackpadThreeFingerVertSwipeGesture
        - TrackpadThreeFingerHorizSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Three finger swipe on Bluetooth trackpads is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
        - TrackpadThreeFingerVertSwipeGesture
        - TrackpadThreeFingerHorizSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Three finger swipe on current host is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - names: # in Apple Global Domain
        - com.apple.trackpad.threeFingerVertSwipeGesture
        - com.apple.trackpad.threeFingerHorizSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
