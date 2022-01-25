{#-
    Customizes window minimize animation to dock.
    Values: string [default: genie]

    References:
      https://macos-defaults.com/dock/mineffect.html
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- set options = ['genie', 'scale', 'suck'] -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.dock_minimize', 'defined') %}

Dock window minimize animation is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: mineffect
    - value: {{ user.macos.animations.dock_minimize if user.macos.animations.dock_minimize in options else 'genie' }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
