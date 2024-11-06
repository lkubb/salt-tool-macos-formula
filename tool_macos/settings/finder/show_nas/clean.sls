# vim: ft=sls

{#-
    Resets display status of mounted network drives on desktop to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.show_nas", "defined") %}

Display status of NAS drives on desktop is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: ShowMountedServersOnDesktop
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
