{#-
    Customizes multidisplay swoosh animation activation status.

    Mind that the actual setting is called "...off",
    so the pillar value is inverted for consistency.

    There's also workspaces-auto-swoosh that disables the underlying behavior.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.multidisplay_swoosh', 'defined') %}

Multidisplay swoosh animation activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: workspaces-swoosh-animation-off
    - value: {{ False == user.macos.animations.multidisplay_swoosh | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
