{#-
    Resets Help viewer window floating status to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.help_window_floats', 'defined') %}

Help viewer window floating status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.helpviewer
    - name: DevMode
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
