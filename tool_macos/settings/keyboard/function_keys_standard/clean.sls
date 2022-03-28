{#-
    Resets default state of function keys to default (behave as system function keys).
    You might need to reboot after applying.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.function_keys_standard', 'defined') %}

Default state of function keys is reset to default (system function) for {{ user.name }}:
  macosdefaults.absent:
    - name: com.apple.keyboard.fnState  # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
