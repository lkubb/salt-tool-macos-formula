# vim: ft=sls

{#- @internal
    Resets four finger horizontal swipes to defaults (disabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") %}
{%-   from tpldir ~ "/map.jinja" import status with context %}

{%-   if status is not sameas False %}

Four finger horizontal swipe on internal trackpad reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadFourFingerHorizSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger horizontal swipe on bluetooth trackpad reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadFourFingerHorizSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger horizontal swipe on current host reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.trackpad.fourFingerHorizSwipeGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%-   endif %}
{%- endfor %}
