# vim: ft=sls

{#-
    Resets status of dictation to default (disabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.textinput", "defined") | selectattr("macos.textinput.dictation", "defined") %}

Dictation reset to default (disabled) for user {{ user.name }} part 1:
  macosdefaults.absent:
    - domain: com.apple.assistant.support
    - name: Dictation Enabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Dictation is reset to default (disabled) for user {{ user.name }} part 2:
  macdefaults.absent:
    - domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs
    - names:
      - DictationIMMasterDictationEnabled
      - DictationIMIntroMessagePresented
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
