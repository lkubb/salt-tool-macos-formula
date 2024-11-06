# vim: ft=sls

{#-
    Resets global toolbar button shape visibility to default (hidden).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.toolbar_button_shapes", "defined") %}

Toolbar button shape visibility is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.universalaccess
    - name: showToolbarButtonShapes
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
