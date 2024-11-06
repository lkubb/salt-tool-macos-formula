# vim: ft=sls

{#-
    Customizes Siri keyboard shortcut.

    .. note::

        Note that custom keyboard shortcuts are currently not supported here.
        Needs a logout to apply.

    Values:
        - bool [default: false]

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/siri.sh
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{#- default means Off / Hold microphone key. custom would be 7 and needs CustomizedKeyboardShortcut dict #}
{%- set options = {
      "default": 0,
      "cmd_space": 2,
      "opt_space": 3,
      "fn_space": 4,
      "cmd_shift_space": 6,
} %}

{%- set symbolichotkey = {
      "default": {
        "enabled": False},
      "cmd_space": {
        "enabled": True,
        "value": {
          "parameters": [32, 49, 2148532224],
          "type": "modifier"
        }},
      "opt_space": {
        "enabled": True,
        "value": {
          "parameters": [32, 49, 2148007936],
          "type": "modifier"
        }},
      "fn_space": {
        "enabled": True,
        "value": {
          "parameters": [32, 49, 8388608],
          "type": "standard"
        }},
      "cmd_shift_space": {
        "enabled": True,
        "value": {
          "parameters": [32, 49, 1179648],
          "type": "standard"
        }},
} %}

{%- for user in macos.users | selectattr("macos.siri", "defined") | selectattr("macos.siri.keyboard_shortcut", "defined") %}

Siri keyboard shortcut is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.Siri
    - name: HotkeyTag
    - value: {{ options.get(user.macos.siri.keyboard_shortcut, 0) | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

HotKey action for Siri is managed for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.symbolichotkeys
    - name: AppleSymbolicHotKeys:176
    - value: {{ symbolichotkey.get(user.macos.siri.keyboard_shortcut, symbolichotkey.default) }}
    - vtype: dict
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
