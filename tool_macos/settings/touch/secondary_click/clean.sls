# vim: ft=sls

{#-
    Resets secondary click touch gesture activation status to default (two-finger enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.secondary_click", "defined") %}

Secondary click activation status reset to default (two-finger) for user {{ user.name }}:
  macosdefaults.absent:
    - name: ContextMenuGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on internal trackpad reset to default (two-finger) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - TrackpadRightClick
        - TrackpadCornerSecondaryClick
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on bluetooth trackpad reset to default (two-finger) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
        - TrackpadRightClick
        - TrackpadCornerSecondaryClick
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on current host reset to default (two-finger) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - names: # in Apple Global Domain
        - com.apple.trackpad.enableSecondaryClick
        - com.apple.trackpad.trackpadCornerClickBehavior
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

{%- endfor %}
