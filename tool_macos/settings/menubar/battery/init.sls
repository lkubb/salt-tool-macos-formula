{#-
    Customizes display behavior of Battery widget in Menu Bar and Control Center.

    Values:
        - dict

            * menu: bool [default: true]
            * control: bool [default: false]
            * percent: bool [default: false]
-#}

{#- Before Big Sur, percent status was found in com.apple.menuextra.battery as ShowPercent. -#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.battery', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import status with context %}

Display behavior of Battery widget is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - names:
  {%- if status %}
        - Battery:
            - value: {{ status | int }}
            - vtype: int
  {%- endif %}
  {%- if user.macos.menubar.battery.percentage is defined %}
        - BatteryShowPercentage:
            - value: {{ user.macos.menubar.battery.percentage | to_bool }}
            - vtype: bool
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
