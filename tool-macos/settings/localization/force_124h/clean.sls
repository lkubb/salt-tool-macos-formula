{#-
    Resets forcing of 12h / 24h format to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.localization', 'defined') | selectattr('macos.localization.force_124h', 'defined') %}

Time format forcing is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in NSGlobalDomain
        - AppleICUForce12HourTime
        - AppleICUForce24HourTime
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded
{%- endfor %}
