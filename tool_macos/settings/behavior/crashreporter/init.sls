{#-
    Customizes behavior when apps have crashed.

    Values:
        - bool [default: true = show Crash Reporter]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.crashreporter', 'defined') %}
  {%- set u = user.macos.behavior.crashreporter %}
Behavior when apps have crashed is managed for user {{ user.name }}:
  macosdefaults.{{ 'write' if u else 'absent'  }}:
    - domain: com.apple.CrashReporter
    - name: DialogType
  {%- if u %}
    - value: none
    - vtype: string
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
