{#-
    Resets pointer locating by shaking setting to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.locate_pointer', 'defined') %}

Pointer locating by shaking setting is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: CGDisableCursorLocationMagnification # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
