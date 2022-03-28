{#-
    Resets scrollbar visibility setting to default (automatic).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.scrollbars_visibility', 'defined') %}

Scrollbars visibility setting is reset to default (automatic) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleShowScrollBars # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
