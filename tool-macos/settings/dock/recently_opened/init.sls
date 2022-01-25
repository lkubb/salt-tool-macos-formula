{#-
    Customizes dock behavior regarding recently opened apps.
    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.recently_opened', 'defined') %}

Dock behavior regarding recently opened applications is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: show-recents
    - value: {{ user.macos.dock.recently_opened | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
