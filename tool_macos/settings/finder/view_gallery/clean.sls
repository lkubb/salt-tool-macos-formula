# vim: ft=sls

{#-
    Resets default Finder Gallery View settings for all folders to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.view_gallery", "defined") %}

Default Gallery View settings are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - names:
        - StandardViewSettings:IconViewSettings
        - StandardViewOptions:ColumnViewOptions
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
