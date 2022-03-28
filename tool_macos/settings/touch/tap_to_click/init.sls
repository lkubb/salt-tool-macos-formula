{#-
    Customizes tap-to-click activation status.

    Values:
        - bool [default: false]

    .. note::

        Note that this has to be active when you enable three finger drag.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') %}
  {%- if user.macos.touch.tap_to_click is defined %}
    {%- set value = user.macos.touch.tap_to_click %}
  {%- endif %}
  {%- if user.macos.touch.drag is defined and user.macos.touch.drag %}
    {%- if value is defined and not value %}
      {%- do salt['log.warning'](
            "When three finger drag is enabled, tap to click needs to be active as well. " ~
            "Overriding tap_to_click = False for user {}.".format(user.name))
      %}
    {%- endif %}
    {%- set value = True %}
  {%- endif %}

  {%- if value is defined %}
Tap to click touch gesture on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: Clicking
    - value: {{ value | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Tap to click touch gesture on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - name: Clicking
    - value: {{ value | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Tap to click touch gesture on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - name: com.apple.mouse.tapBehavior # in Apple Global Domain
    - value: {{ value | int }}
    - vtype: int # yup
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
  {%- endif %}
{%- endfor %}
