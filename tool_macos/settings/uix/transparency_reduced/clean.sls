# vim: ft=sls

{#-
    Resets transparency in menus and windows setting to default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.transparency_reduced", "defined") %}

Transparency in menus and windows setting is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.universalaccess
    - name: reduceTransparency
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
