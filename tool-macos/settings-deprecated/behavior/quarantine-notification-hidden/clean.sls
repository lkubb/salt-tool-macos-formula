{#-
    Resets quarantine notification display status to default (enabled).
    Deprecated on Big Sur. Might need a reboot to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.quarantine_notification', 'defined') %}

Quarantine notification is managed for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.LaunchServices
    - name: LSQuarantine
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
