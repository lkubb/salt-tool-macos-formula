# vim: ft=sls

{#-
    Resets display status of Spotlight widget in Menu Bar to default (hidden).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.menubar", "defined") | selectattr("macos.menubar.spotlight", "defined") %}

Display status of Spotlight widget in Menu Bar is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.Spotlight
    - name: NSStatusItem Visible Item-0
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
