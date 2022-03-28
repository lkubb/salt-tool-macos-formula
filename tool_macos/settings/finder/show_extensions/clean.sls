{#-
    Resets display status of file extensions to default (hidden).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.show_extensions', 'defined') %}

Display status of file extensions is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleShowAllExtensions # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
