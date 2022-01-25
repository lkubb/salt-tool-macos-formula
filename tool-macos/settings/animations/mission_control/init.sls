{#-
    Customizes Mission Control animation duration.

    Values: float [default: 0.5?]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.mission_control', 'defined') %}

Mission Control animation time is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: expose-animation-duration
    - value: {{ user.macos.animations.mission_control | float }}
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
