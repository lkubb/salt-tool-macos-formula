# vim: ft=sls

{#-
    Resets scrolling direction to default (natural).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.natural_scrolling", "defined") %}

Natural scrolling state is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: com.apple.swipescrolldirection # in Apple Global Domain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
