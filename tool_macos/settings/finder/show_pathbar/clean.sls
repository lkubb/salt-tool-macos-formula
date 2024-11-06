# vim: ft=sls

{#-
    Resets Finder Path Bar visibility to default (hidden).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.show_pathbar", "defined") %}

Finder Path Bar visibility is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: ShowPathbar
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
