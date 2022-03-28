{#-
    Resets activation of press-and-hold behavior to default (enabled).
    You might need to reboot after applying.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.press_and_hold', 'defined') %}

Press-and-hold behavior is reset to default (enabled) for {{ user.name }}:
  macosdefaults.absent:
    - name: ApplePressAndHoldEnabled  # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
