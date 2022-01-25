{#-
    Resets display status of Wifi status widget in Menu Bar to default (shown).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.wifi', 'defined') %}

Display status of Wifi status widget in Menu Bar is reset to default (shown) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.controlcenter
    - name: WiFi
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
{%- endfor %}
