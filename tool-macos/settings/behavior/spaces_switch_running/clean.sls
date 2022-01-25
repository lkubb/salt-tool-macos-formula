{#-
    Resets switching of spaces when clicking a running app icon in the Dock to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.spaces_switch_running', 'defined') %}

Switching of spaces when running app is selected is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleSpacesSwitchOnActivate # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
