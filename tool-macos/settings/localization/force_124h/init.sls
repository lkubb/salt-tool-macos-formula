{#-
    Customizes forcing of 12h / 24h format.

    Values: string [12h / 24h]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.localization', 'defined') | selectattr('macos.localization.force_124h', 'defined') %}
  {%- set twelve = user.macos.localization.force_124h == '12h' %}

Time format forcing is managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in NSGlobalDomain
        - AppleICUForce12HourTime:
            - value: {{ twelve | to_bool }}
        - AppleICUForce24HourTime:
            - value: {{ False == twelve | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded
{%- endfor %}
