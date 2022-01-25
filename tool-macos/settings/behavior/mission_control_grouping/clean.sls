{#-
    Resets Mission Control window grouping behavior to default (group by application).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.mission_control_grouping', 'defined') %}

Mission Control window grouping behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: expose-group-by-app
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
