{#-
    Customizes Finder preference for tabs instead of windows.
    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.prefer_tabs', 'defined') %}

Finder preference for tabs is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: FinderSpawnTab
    - value: {{ user.macos.finder.prefer_tabs | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
