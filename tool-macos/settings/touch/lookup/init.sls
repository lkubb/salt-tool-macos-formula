{#-
    Customizes lookup touch gesture.
    Values: bool [default: true = force click]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.lookup', 'defined') %}
  {%- set force_click = (True == user.macos.touch.lookup) %}
  {%- set three_finger = 2 if 'three' == user.macos.touch.lookup else 0 %}

Three finger tap to trigger lookup on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadThreeFingerTapGesture
    - value: {{ three_finger | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger tap to trigger lookup on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadThreeFingerTapGesture
    - value: {{ three_finger | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Three finger tap to trigger lookup on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.trackpad.threeFingerTapGesture # in Apple Global Domain
    - value: {{ three_finger | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Force click to trigger lookup on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.trackpad.forceClick # in Apple Global Domain
    - value: {{ force_click | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
