{#-
    Customizes display status of Accesibility Shortcuts widget in Menu Bar and Control Center.
    Values:
      menu: bool [default: false]
      control: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.accessibility', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import status with context %}

Display status of Accesibility Shortcuts widget is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - name: UserSwitcher
    - value: {{ status | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
