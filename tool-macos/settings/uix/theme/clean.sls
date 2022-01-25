{#-
    Resets system theme to default (light).
    Currently needs a logout to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.theme', 'defined') %}

System theme is reset to default (light) for user {{ user.name }}:
  macosdefaults.absent:
    - names:
        - AppleInterfaceStyle
        - AppleInterfaceStyleSwitchesAutomatically
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
