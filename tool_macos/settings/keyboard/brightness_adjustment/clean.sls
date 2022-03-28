{#-
    Resets keyboard brightness adjustment behavior to default (adjust in low light, not on inactivity).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.keyboard is defined and macos.keyboard.brightness_adjustment is defined %}

Keyboard brightness adjustment behavior is reset to default:
  macosdefaults.absent:
  # this is the default path of root user for preferences, so it could be run without the full path
    - domain: /var/root/Library/Preferences/com.apple.CoreBrightness.plist
    - names:
        - KeyboardBacklightABEnabled
        # this might reset more since the actual setting is in a nested dict @TODO
        - KeyboardBacklight
        - Keyboard Dim Time
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - corebrightnessd was reloaded
{%- endif %}
