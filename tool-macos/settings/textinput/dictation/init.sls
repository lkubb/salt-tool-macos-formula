{#-
    Customizes status of dictation.
    Values: bool [default: false]

    @TODO
    Use Enhanced Dictation
    Allows offline use and continuous dictation with live feedback
    if [ -d '/System/Library/Speech/Recognizers/SpeechRecognitionCoreLanguages/en_US.SpeechRecognition' ]; then
      defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs \
         DictationIMPresentedOfflineUpgradeSuggestion -bool true
      defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs \
        DictationIMSIFolderWasUpdated -bool true
      defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs \
        DictationIMUseOnlyOfflineDictation -bool true
    fi

    References:
      https://github.com/joeyhoer/starter/blob/master/system/keyboard.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.dictation', 'defined') %}
# @TODO assistantd reload?
Dictation managed for user {{ user.name }} part 1:
  macosdefaults.write:
    - domain: com.apple.assistant.support
    - name: Dictation Enabled
    - value: {{ user.macos.textinput.dictation | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Dictation is managed for user {{ user.name }} part 2:
  macdefaults.write:
    - domain: com.apple.speech.recognition.AppleSpeechRecognition.prefs
    - names:
      - DictationIMMasterDictationEnabled
      - DictationIMIntroMessagePresented
    - value: {{ user.macos.textinput.dictation | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
