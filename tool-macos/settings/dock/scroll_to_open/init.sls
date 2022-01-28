{#-
    Customizes dock behavior regarding scrolling over tiles (open app vs do nothing).

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.scroll_to_open', 'defined') %}

Dock behavior regarding scrolling over tiles is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: scroll-to-open
    - value: {{ user.macos.dock.scroll_to_open | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
