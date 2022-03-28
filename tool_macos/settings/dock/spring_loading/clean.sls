{#-
    Resets drag hover behavior of all dock tiles (spring loading) to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.spring_loading', 'defined') %}

Dock tile drag hover behavior (spring loading) is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: enable-spring-load-actions-on-all-items
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
