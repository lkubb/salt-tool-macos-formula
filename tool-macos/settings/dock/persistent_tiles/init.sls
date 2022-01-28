{#-
    Customizes availability of persistent dock tiles.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.persistent_tiles', 'defined') %}

Availability of persistent dock tiles is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: static-only
    {#- Mind that the actual setting is called "static-only". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ False == user.macos.dock.persistent_tiles | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
