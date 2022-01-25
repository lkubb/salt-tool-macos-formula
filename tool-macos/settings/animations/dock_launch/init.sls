{#-
    Customizes app startup animation in dock.
    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.dock_launch', 'defined') %}

Dock app startup animation is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: launchanim
    - value: {{ user.macos.animations.dock_launch | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
