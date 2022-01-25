{#-
    Resets whether Handoff is allowed between Mac and other iCloud devices
    to default.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.handoff_allowed', 'defined') %}

Handoff behavior is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.coreservices.useractivityd
    - names:
        - ActivityAdvertisingAllowed
        - ActivityReceivingAllowed
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
