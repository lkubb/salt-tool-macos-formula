{#-
    Customizes display status of User Switcher widget in Menu Bar and Control Center.

    Values:
        - dict

          * menu: bool [default: false]
          * control: bool [default: false]
          * menu_show: string [default: icon]
            - icon
            - username
            - fullname

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/users-groups.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set icon_options = {
  'icon': 0,
  'username': 1,
  'fullname': 2
  } %}

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.userswitcher', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import status with context %}

Display status of User Switcher widget is managed for user {{ user.name }}:
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

  {%- if user.macos.menubar.userswitcher.menu_show is defined %}
User Switcher widget display style is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: userMenuExtraStyle # in NSGlobalDomain
    - value: {{ icon_options.get(user.macos.menubar.userswitcher.menu_show, 0) }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - ControlCenter was reloaded # either will do
      - SystemUIServer was reloaded # either will do
  {%- endif %}
{%- endfor %}
