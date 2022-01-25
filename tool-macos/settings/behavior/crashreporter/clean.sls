{#-
    Resets behavior when apps have crashed to default (show Crash Reporter).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.crashreporter', 'defined') %}

Behavior when apps have crashed is managed for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.CrashReporter
    - name: DialogType
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
