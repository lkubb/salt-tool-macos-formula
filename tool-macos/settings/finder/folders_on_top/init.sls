{#-
    Customizes Finder sorting behavior regarding folders (separate on top/in line with files).
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.folders_on_top', 'defined') %}

Finder sorting behavior regarding folders is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: _FXSortFoldersFirst
    - value: {{ user.macos.finder.folders_on_top | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
