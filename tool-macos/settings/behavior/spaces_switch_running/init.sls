{#-
    Customizes switching of spaces when clicking a running app icon in the Dock (switch vs new window).

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.spaces_switch_running', 'defined') %}

Switching of spaces when running app is selected is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleSpacesSwitchOnActivate # in NSGlobalDomain
    - value: {{ user.macos.behavior.spaces_switch_running | to_bool }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
