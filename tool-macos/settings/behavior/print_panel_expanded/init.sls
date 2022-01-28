{#-
    Customizes default state of print panel (expanded vs collapsed).

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.print_panel_expanded', 'defined') %}

Default state of print panel is managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in NSGlobalDomain
        - PMPrintingExpandedStateForPrint
        - PMPrintingExpandedStateForPrint2
    - value: {{ user.macos.behavior.print_panel_expanded | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
