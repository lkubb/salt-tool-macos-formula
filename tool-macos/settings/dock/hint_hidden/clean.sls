{#-
    Resets dock hint behavior regarding hidden apps to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.hint_hidden', 'defined') %}

Dock hint behavior for hidden apps is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: showhidden
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
