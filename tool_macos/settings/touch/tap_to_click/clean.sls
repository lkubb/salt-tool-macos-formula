{#-
    Resets tap-to-click activation status to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}
  {%- if user.macos.touch.tap_to_click is defined %}
    {%- set value = user.macos.touch.tap_to_click %}
  {%- endif %}
  {%- if user.macos.touch.drag is defined and user.macos.touch.drag %}
    {%- set value = True %}
  {%- endif %}

  {%- if value is defined %}
Tap to click touch gesture on internal trackpad is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: Clicking
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Tap to click touch gesture on bluetooth trackpad is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: Clicking
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Tap to click touch gesture on current host is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - name: com.apple.mouse.tapBehavior # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
  {%- endif %}
{%- endfor %}
