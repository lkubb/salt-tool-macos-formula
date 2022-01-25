{#-
    Resets four finger vertical swipes to defaults (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import status with context %}

  {%- if status is not sameas False %}
Four finger vertical swipe on internal trackpad is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: TrackpadFourFingerVertSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger vertical swipe on bluetooth trackpad is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: TrackpadFourFingerVertSwipeGesture
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded

Four finger vertical swipe on current host is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.trackpad.fourFingerVertSwipeGesture # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
  {%- endif %}
{%- endfor %}
