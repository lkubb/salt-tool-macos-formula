{#-
    Customizes drag hover behavior of all dock tiles (spring loading).
    Values: bool [default: false]

    References:
      https://macos-defaults.com/misc/enable-spring-load-actions-on-all-items.html
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.spring_loading', 'defined') %}

Dock tile drag hover behavior (spring loading) is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: enable-spring-load-actions-on-all-items
    - value: True
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
