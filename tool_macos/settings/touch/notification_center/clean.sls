# vim: ft=sls

{#-
    Resets Notification Center touch gesture activation status to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.notification_center", "defined") %}

Notification Center gesture on internal trackpad is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadTwoFingerFromRightEdgeSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Notification Center gesture on bluetooth trackpad is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadTwoFingerFromRightEdgeSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Notification Center gesture on current host is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
