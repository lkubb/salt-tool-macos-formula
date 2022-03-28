{#-
    Resets highlight on hover behavior of stack tiles (items) to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.stack_hover', 'defined') %}

Highlight on hover behavior of stack tiles is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: mouse-over-hilite-stack
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
