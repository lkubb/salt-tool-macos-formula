{#-
    Customizes behavior when selecting an app from the dock. When enabled,
    all other apps will be hidden. (single application mode)
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.single_app', 'defined') %}

Dock behavior regarding selecting an app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: single-app
    - value: {{ user.macos.dock.single_app | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
