{#-
    Resets action when pressing Fn key to default (change input source?).
    You might need to reboot after applying.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set symbolichotkey = {
  'default': {
    'enabled': False,
    'value': {
      'parameters': [65535, 65535, 0],
      'type': 'standard'
    }},
  'dictation': {
    'enabled': True,
    'value': {
      'parameters': [8388608, 4286578687],
      'type': 'modifier'
    }}
} %}

{%- for user in macos.users | selectattr('macos.keyboard', 'defined') | selectattr('macos.keyboard.function_keys_standard', 'defined') %}
  {%- set u = user.macos.keyboard.fn_action %}

  {#- the following is used to avoid resetting only semi-related settings. there are
      other possibilities of triggering the dictation action #}

  {%- set current_dictation = salt['macosdefaults.read_more'](
          'AppleSymbolicHotKeys:164', 'com.apple.symbolichotkeys', user.name) %}
  {%- set dictation_shk_managed = current_dictation in symbolichotkey.values() %}

Fn key action is reset to default for {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.HIToolbox
    - name: AppleFnUsageType
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

  {%- if dictation_shk_managed %}
HotKey action for dictation is reset to default for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.symbolichotkeys
    - name: AppleSymbolicHotKeys:164
    - value: {{ symbolichotkey.default }}
    - vtype: dict
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
  {%- endif %}
{%- endfor %}
