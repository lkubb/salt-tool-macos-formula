# vim: ft=sls

{#-
    Resets dock behavior on hover (magnification) to default (disabled, size=128).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.magnification", "defined") %}

Dock hover magnification is reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - names:
        - magnification
        - largesize
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
