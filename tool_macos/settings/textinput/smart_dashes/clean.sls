{#-
    Resets activation state of smart dashes -- to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.smart_dashes', 'defined') %}

Activation of smart dashes is reset to default (enabled) for {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticDashSubstitutionEnabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
