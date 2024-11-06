# vim: ft=sls

{#-
    Resets Finder quittable status to default (not quittable).
    Values: bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.quittable", "defined") %}

Finder quittable status is reset to default (false) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: QuitMenuItem
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
