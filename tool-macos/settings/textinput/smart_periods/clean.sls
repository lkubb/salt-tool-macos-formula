{#-
    Resets activation state of smart periods (2x space = .) to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.smart_periods', 'defined') %}

Activation of smart periods is reset to default (enabled) for {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticPeriodSubstitutionEnabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
