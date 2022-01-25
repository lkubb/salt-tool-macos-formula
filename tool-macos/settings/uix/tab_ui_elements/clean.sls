{#-
    Resets tab keypress action in modal dialogs etc. to default.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.tab_ui_elements', 'defined') %}

Tab keypress action in modal dialogs etc. is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleKeyboardUIMode # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
