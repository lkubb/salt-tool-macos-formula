{#-
    Resets delay and rate of key repeats to defaults.
    You might need to reboot after applying.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.repeat', 'defined') %}
  {%- set u = user.macos.textinput.repeat %}

Key repeat behavior is reset to defaults for {{ user.name }}:
  macosdefaults.absent:
    - names:   # in NSGlobalDomain
  {%- if u.rate is defined %}
        - KeyRepeat
  {%- endif %}
  {%- if u.delay is defined %}
        - InitialKeyRepeat
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
