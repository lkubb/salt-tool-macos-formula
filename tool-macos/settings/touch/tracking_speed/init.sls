{#-
    Customizes tracking speed.
    Values: float [0-3, default: 1?]

    In System Preferences, the discrete values are:
    0 - 0.125 - 0.5 - 0.685 - 0.875 - 1 - 1.5 - 2 - 2.5 - 3
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.tracking_speed', 'defined') %}

Tracking speed is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.trackpad.scaling
    - value: {{ user.macos.touch.tracking_speed | float }}
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
