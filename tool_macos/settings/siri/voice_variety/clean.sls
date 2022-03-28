{#-
    Resets Siri voice variety to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.voice_variety', 'defined') %}

Siri voice variety is reset to defaults for user {{ user.name }}:
  macosdefaults.absent_less:
    - domain: com.apple.assistant.backedup
    - names:
  {%- if user.macos.siri.voice_variety.language is defined %}
        - Output Voice:Language
  {%- endif %}
  {%- if user.macos.siri.voice_variety.speaker is defined %}
        - Output Voice:Name
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
