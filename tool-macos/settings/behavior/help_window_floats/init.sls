{#-
    Customizes Help viewer window floating status.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.help_window_floats', 'defined') %}

Help viewer window floating status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.helpviewer
    - name: DevMode
    - value: {{ False == user.macos.behavior.help_window_floats }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
