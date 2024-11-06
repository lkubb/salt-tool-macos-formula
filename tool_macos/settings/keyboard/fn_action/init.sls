# vim: ft=sls

{#-
    Customizes action when pressing Fn key.

    .. note::
        You might need to reboot after applying.

    Values:
        - string [default: input_source ?]

          * none
          * dictation
          * emoji
          * input_source
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set options = {
      "none": 0,
      "dictation": 3,
      "emoji": 2,
      "input_source": 1
} %}

{%- set symbolichotkey = {
      "default": {
        "enabled": False,
        "value": {
          "parameters": [65535, 65535, 0],
          "type": "standard"
        },
      },
      "dictation": {
        "enabled": True,
        "value": {
          "parameters": [8388608, 4286578687],
          "type": "modifier"
        },
      },
} %}

{%- for user in macos.users | selectattr("macos.keyboard", "defined") | selectattr("macos.keyboard.function_keys_standard", "defined") %}
{%-   set u = user.macos.keyboard.fn_action %}

{#-   the following is used to avoid resetting only semi-related settings. there are
      other possibilities of triggering the dictation action #}

{%-   set current_dictation = salt["macosdefaults.read_more"](
          "AppleSymbolicHotKeys:164", "com.apple.symbolichotkeys", user.name) %}
{%-   set dictation_shk_managed = current_dictation in symbolichotkey.values() %}

Fn key action is managed for {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.HIToolbox
    - name: AppleFnUsageType
    - value: {{ options.get(u, 1) | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

{%-   if dictation_shk_managed %}
HotKey action for dictation is only managed for Fn key for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.symbolichotkeys
    - name: AppleSymbolicHotKeys:164
    - value: {{ symbolichotkey.dictation if u == "dictation" else symbolichotkey.default }}
    - vtype: dict
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%-   endif %}
{%- endfor %}
