{#-
    Resets global preference for tabs to default (when in fullscreen).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- set options = ['manual', 'fullscreen', 'always'] %}

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.tab_preference', 'defined') %}
  {%- set u = user.macos.behavior.tab_preference %}

Global preference for tabs is reset to default (in fullscreen) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleWindowTabbingMode # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
