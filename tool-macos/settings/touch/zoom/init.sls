{#-
    Customizes zoom gesture activation status.
    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.zoom', 'defined') %}

Zoom touch gesture on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadPinch
    - value: {{ user.macos.touch.zoom | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Zoom touch gesture on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadPinch
    - value: {{ user.macos.touch.zoom | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Zoom touch gesture on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.pinchGesture # in Apple Global Domain
    - value: {{ user.macos.touch.zoom | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
