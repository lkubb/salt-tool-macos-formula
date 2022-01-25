{#-
    Customizes display status of Airdorp widget in Menu Bar.
    Values: bool [default: false]
-#}

{#-
    Status values correspond to both menubar and control center settings.

    4321
    0011 =  3: both on
    0110 =  6: menubar on
    1001 =  9: control center on
    1100 = 12: both off

    bit 1/3 control center on / off
    bit 2/4 menubar        on / off

    Since AirDrop does not have a Control Center widget, bits 1/3 are both unset.
    That results in decimal 2/8 on/off.

    0010 =  2: menubar on
    1000 =  8: menubar off
 -#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.airdrop', 'defined') %}
  {%- set status = 2 if user.macos.menubar.airdrop else 8 %}
Display status of Airdrop widget in Menu Bar is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - name: AirDrop
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
