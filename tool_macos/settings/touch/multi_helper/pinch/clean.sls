# vim: ft=sls

{#- @internal
    Resets four/five finger pinch gestures to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") %}
{%-   set u = user.macos.touch %}
{%-   set managed = (u.show_desktop is defined or u.launchpad is defined) %}

{%-   if managed %}

Pinch gesture activation status for internal trackpad is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
      - TrackpadFourFingerPinchGesture
      - TrackpadFiveFingerPinchGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Pinch gesture activation status for bluetooth trackpad is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
      - TrackpadFourFingerPinchGesture
      - TrackpadFiveFingerPinchGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Pinch gesture activation status on current host is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: Apple Global Domain
    - names:
      - com.apple.trackpad.fourFingerPinchSwipeGesture
      - com.apple.trackpad.fiveFingerPinchSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%-   endif %}
{%- endfor %}
