{#-
    Customizes bounce animation in dock (alert on changes/needs attention).

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.dock_bounce', 'defined') %}

Dock bounce animation is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: no-bouncing
    {#- Mind that the actual setting is called "no-bouncing". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ False == user.macos.animations.dock_bounce | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
