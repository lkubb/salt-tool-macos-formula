{#-
    Customizes global toolbar button shape visibility.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.toolbar_button_shapes', 'defined') %}

Toolbar button shape visibility is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.universalaccess
    - name: showToolbarButtonShapes
    - value: {{ user.macos.uix.toolbar_button_shapes | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
