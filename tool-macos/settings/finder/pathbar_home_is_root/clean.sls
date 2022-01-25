{#-
    Resets Finder Pathbar root directory to default (disk).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.pathbar_home_is_root', 'defined') %}

Finder Pathbar root directory is reset to default (disk) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: PathBarRootAtHome
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
