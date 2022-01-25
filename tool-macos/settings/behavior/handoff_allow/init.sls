{#-
    Customizes whether Handoff is allowed between Mac and other iCloud devices.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.handoff_allowed', 'defined') %}

Handoff behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.coreservices.useractivityd
    - names:
        - ActivityAdvertisingAllowed
        - ActivityReceivingAllowed
    - value: {{ user.macos.behavior.handoff_allowed | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
