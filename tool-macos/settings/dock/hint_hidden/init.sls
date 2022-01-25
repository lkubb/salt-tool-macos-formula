{#-
    Customizes dock hints regarding hidden apps (Cmd + h => translucent dock icon).
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.hint_hidden', 'defined') %}

Dock hint setting for hidden apps is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: showhidden
    - value: {{ user.macos.dock.hint_hidden | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
