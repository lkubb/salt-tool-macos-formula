{#-
    Customizes three finger drag touch gesture activation status.
    Values: bool [default: false]

    Tap to click needs to be active as well for this to be active.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require
  - ..multi_helper.three
  - ..tap_to_click

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.drag', 'defined') %}

Three finger drag gesture on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadThreeFingerDrag
    - value: {{ user.macos.touch.drag | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger drag gesture on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadThreeFingerDrag
    - value: {{ user.macos.touch.drag | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger drag gesture on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.threeFingerDragGesture # in Apple Global Domain
    - value: {{ user.macos.touch.drag | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
