{#-
    Customizes keyboard brightness adjustment behavior.
    Values:
      low_light: bool [default: true]
      after: int [seconds of inactivity, default: 0. 0 to disable]

    This was found in /Library/Preferences/com.apple.iokit.AmbientLightSensor
    as Automatic Keyboard Enabled and com.apple.BezelServices as kdim.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.keyboard is defined and macos.keyboard.brightness_adjustment is defined %}

Keyboard brightness adjustment behavior is managed:
  macosdefaults.set:
  # this is the default path of root user for preferences, so it could be run without the full path
    - domain: /var/root/Library/Preferences/com.apple.CoreBrightness.plist
    - names:
  {%-  if macos.keyboard.brightness_adjustment.low_light is defined %}
        - KeyboardBacklightABEnabled:
            - value: {{ macos.keyboard.brightness_adjustment.low_light | to_bool}}
            - vtype: bool
  {%- endif %}
  {%-  if macos.keyboard.brightness_adjustment.after is defined %}
        - KeyboardBacklight:KeyboardBacklightIdleDimTime:
            - value: {{ macos.keyboard.brightness_adjustment.after | int }}
            - vtype: int
        # not sure if this is needed, works without it, but sys prefs sets it
        - Keyboard Dim Time:
            - value: {{ macos.keyboard.brightness_adjustment.after | int }}
            - vtype: int
  {%- endif %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - corebrightnessd was reloaded
{%- endif %}
