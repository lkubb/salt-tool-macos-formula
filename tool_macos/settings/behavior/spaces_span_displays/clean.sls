# vim: ft=sls

{#-
    Resets spaces separation of different displays to default (separate per display).
    Needs a logout to apply.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.spaces_span_displays", "defined") %}

Spaces separation of different displays is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.spaces
    - name: spans-displays
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
