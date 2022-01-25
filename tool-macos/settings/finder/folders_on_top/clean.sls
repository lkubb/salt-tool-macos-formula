{#-
    Resets Finder sorting behavior regarding folders to default (in line with files).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.folders_on_top', 'defined') %}

Finder sorting behavior regarding folders is reset to default (in line with files) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: _FXSortFoldersFirst
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
