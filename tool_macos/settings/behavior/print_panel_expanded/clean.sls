# vim: ft=sls

{#-
    Resets default state of print panel to default (collapsed).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.print_panel_expanded", "defined") %}
{%-   set u = user.macos.behavior.print_panel_expanded %}

Default state of print panel is reset to default (collapsed) for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in NSGlobalDomain
        - PMPrintingExpandedStateForPrint
        - PMPrintingExpandedStateForPrint2
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
