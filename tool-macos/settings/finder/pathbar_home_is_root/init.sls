{#-
    Customizes Finder Pathbar root directory (disk vs $HOME).
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.pathbar_home_is_root', 'defined') %}

Finder Pathbar root directory is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: PathBarRootAtHome
    - value: {{ user.macos.finder.pathbar_home_is_root | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
