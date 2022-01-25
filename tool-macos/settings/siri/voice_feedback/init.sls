{#-
    Customizes Siri voice feedback.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.voice_feedback', 'defined') %}

Ask Siri voice feedback status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.assistant.backedup
    - name: Use device speaker for TTS
    - value: {{ 2 if user.macos.siri.voice_feedback else 3 }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
