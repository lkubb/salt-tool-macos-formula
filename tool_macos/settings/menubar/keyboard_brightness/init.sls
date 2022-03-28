{#-
    Customizes display status of Keyboard Brightness widget in Menu Bar.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.keyboard_brightness', 'defined') %}
  {%- set status = 2 if user.macos.menubar.keyboard_brightness else 8 %}
Display status of Keyboard Brightness widget in Menu Bar is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - name: KeyboardBrightness
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
