{#-
    Customizes App Exposé touch gesture.

    Values:
        - bool [default: true]

    .. note::

        Select the number of fingers for vertical swipes by setting
        app_expose_mission_control = three / four. Take care with
        three finger settings, they can conflict easily. This formula
        will try to automatically fall back to sensible values.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.three
  - ..multi_helper.four_vertical

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.app_expose', 'defined') %}

App Expose gesture activation state is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: showAppExposeGestureEnabled
    - value: {{ user.macos.touch.app_expose | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
