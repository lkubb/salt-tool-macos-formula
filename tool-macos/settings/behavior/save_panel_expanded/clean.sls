{#-
    Resets default state of save panel to default (collapsed).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.save_panel_expanded', 'defined') %}

Default state of save panel is reset to default (collapsed) for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in NSGlobalDomain
        - NSNavPanelExpandedStateForSaveMode
        - NSNavPanelExpandedStateForSaveMode2
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
