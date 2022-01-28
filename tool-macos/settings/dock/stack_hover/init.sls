{#-
    Customizes highlight on hover behavior of stack tiles (items).

    Values:
        - bool [default: false]

    References:
        * https://macos-defaults.com/misc/enable-spring-load-actions-on-all-items.html
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.stack_hover', 'defined') %}

Highlight on hover behavior of stack tiles is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: mouse-over-hilite-stack
    - value: {{ user.macos.dock.stack_hover | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
