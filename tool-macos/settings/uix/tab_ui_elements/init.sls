{#-
    Customizes tab keypress action in modal dialogs etc.
    When enabled, switches to next UI element.
    "Full Keyboard Access" light.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.tab_ui_elements', 'defined') %}

Tab keypress action in modal dialogs etc. is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleKeyboardUIMode # in NSGlobalDomain
    - value: {{ 3 if user.macos.uix.tab_ui_elements else 2 }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
