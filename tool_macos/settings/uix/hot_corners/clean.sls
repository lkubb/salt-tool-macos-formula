# vim: ft=sls

{#-
    Resets hot corner settings to defaults (no action/modifier for all).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.hot_corners", "defined") %}
  {%- from tpldir ~ "/map.jinja" import corners with context %}

Hot corner configuration is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - names:
  {%- for corner in corners %}
        - wvous-{{ ".join(corner.split("_") | map("first")) }}-corner
        - wvous-{{ ".join(corner.split("_") | map("first")) }}-modifier
  {%- endfor %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
