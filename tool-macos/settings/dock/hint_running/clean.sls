{#-
    Resets dock hint behavior for running apps to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.hint_running', 'defined') %}

Dock hint behavior for running apps is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: show-process-indicators
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
