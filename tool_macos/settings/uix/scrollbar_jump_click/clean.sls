# vim: ft=sls

{#-
    Resets global default action when clicking scrollbar to default (next page).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.scrollbar_jump_click", "defined") %}

Action when clicking scrollbar is reset to default (next page) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleScrollerPagingBehavior # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
