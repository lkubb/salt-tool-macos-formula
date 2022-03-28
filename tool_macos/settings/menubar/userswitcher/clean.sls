{#-
    Resets display status of User Switcher widget in Menu Bar and Control Center
    to default (hidden/hidden/icon).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.userswitcher', 'defined') %}

Display status of User Switcher widget is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.controlcenter
    - name: UserSwitcher
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do

  {%- if user.macos.menubar.userswitcher.menu_show is defined %}
User Switcher widget display style is reset to default (icon) for user {{ user.name }}:
  macosdefaults.absent:
    - name: userMenuExtraStyle # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
  {%- endif %}
{%- endfor %}
