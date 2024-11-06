# vim: ft=sls

{#-
    Resets three finger drag touch gesture activation status to default (disabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.three.clean
  - ..tap_to_click.clean

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.drag", "defined") %}

Three finger drag gesture on internal trackpad reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadThreeFingerDrag
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger drag gesture on bluetooth trackpad reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadThreeFingerDrag
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger drag gesture on current host reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.trackpad.threeFingerDragGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
