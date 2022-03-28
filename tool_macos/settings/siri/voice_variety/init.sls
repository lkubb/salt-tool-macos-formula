{#-
    Customizes Siri voice variety.

    Values:
        - dict

            * language: string [e.g. en-AU]
            * speaker: string [e.g. gordon]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.voice_variety', 'defined') %}

Siri voice variety is managed for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.assistant.backedup
    - names:
  {%- if user.macos.siri.voice_variety.language is defined %}
        - Output Voice:Language:
            - value: {{ user.macos.siri.voice_variety.language }}
  {%- endif %}
  {%- if user.macos.siri.voice_variety.speaker is defined %}
        - Output Voice:Name:
            - value: {{ user.macos.siri.voice_variety.speaker }}
  {%- endif %}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
