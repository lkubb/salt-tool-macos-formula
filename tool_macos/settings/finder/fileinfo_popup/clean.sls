# vim: ft=sls

{#-
    Resets file info popup expanded panes to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.fileinfo_popup", "defined") %}

File info popup expanded panes are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FXInfoPanesExpanded
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
