# vim: ft=sls

{#-
    Resets Siri voice feedback status to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.siri", "defined") | selectattr("macos.siri.voice_feedback", "defined") %}

Ask Siri voice feedback status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.assistant.backedup
    - name: Use device speaker for TTS
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
