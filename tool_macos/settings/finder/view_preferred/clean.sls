# vim: ft=sls

{#-
    Resets preferred Finder view settings to defaults (group by none, icon view).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.view_preferred", "defined") %}

Desktop icon settings are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - names:
{%-   if user.macos.finder.view_preferred.groupby is defined %}
        - FXPreferredGroupBy
{%-   endif %}
{%-   if user.macos.finder.view_preferred.style is defined %}
        - FXPreferredViewStyle
{%-   endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
