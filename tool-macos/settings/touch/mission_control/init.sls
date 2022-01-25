{#-
    Customizes Mission Control touch gesture.
    Values: bool [default: true]

    Select number of fingers for vertical swipe by setting
    app_expose_mission_control = three / four. Take care with
    three finger settings, they can conflict easily. This formula
    will try to automatically fall back to sensible values.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require
  - ..multi_helper.three
  - ..multi_helper.four_vertical

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.mission_control', 'defined') %}

Mission Control gesture activation state is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: showMissionControlGestureEnabled
    - value: {{ user.macos.touch.mission_control | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
