# vim: ft=sls

{#-
    Resets zoom gesture activation status to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.zoom", "defined") %}

Zoom touch gesture on internal trackpad reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadPinch
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Zoom touch gesture on bluetooth trackpad reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadPinch
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Zoom touch gesture on current host reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.trackpad.pinchGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
