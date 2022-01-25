{#-
    Resets display behavior of Battery widget in Menu Bar and Control Center
    to defaults (shown/hidden/no percentage).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.battery', 'defined') %}
{%- if user.macos.menubar.battery.menu is defined or user.macos.menubar.battery.control is defined %}
  {%- set status = True %}
{%- endif %}
Display behavior of Battery widget is reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.controlcenter
    - names:
  {%- if status is defined %}
        - Battery
  {%- endif %}
  {%- if user.macos.menubar.battery.percentage is defined %}
        - BatteryShowPercentage
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
