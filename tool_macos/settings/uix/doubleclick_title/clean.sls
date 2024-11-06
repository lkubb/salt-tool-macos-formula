# vim: ft=sls

{#-
    Resets action when doubleclicking a window's title to default (maximize).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set options = ["none", "minimize", "maximize"] %}

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.doubleclick_title", "defined") %}

Action when doubleclicking a window's title is reset to default (maximize) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleActionOnDoubleClick # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
