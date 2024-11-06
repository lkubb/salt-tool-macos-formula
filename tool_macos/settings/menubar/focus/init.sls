# vim: ft=sls

{#-
    Customizes display status of Focus widget in Menu Bar.

    Values:
        - when_active [default: when_active]
        - or bool
#}

{#-
    status values correspond to selected value and enabled/disabled state:
    bit 2, when set: on (but also defaults to true if bit 4 is not set)
    bit 4, when set: off (bit 2 has precedence)
    bit 5 0/1: active/always

    54321
    00010 = 2: on, when active
    01000 = 8: off, when active greyed out
    10010 = 18: on, always
    11000 = 24: off, always greyed out

    TL;DR generally:
    bits 1/3 regulate control center on/off (uavailable for focus, therefore both are unset)
    bits 2/4 regulate menu bar on/off
    bit    5 switches active/always
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.menubar", "defined") | selectattr("macos.menubar.focus", "defined") %}
{%-   if user.macos.menubar.focus in [True, False] %}
{%-     set status = 18 if user.macos.menubar.focus else 8 %}
{%-   elif "when_active" == user.macos.menubar.focus %}
{%-     set status = 2 %}
{%-   else %}
{%-     do salt["log.error"]("Invalid value '{}' specified for macos.menubar.focus for user {}!".format(user.macos.menubar.sound, user.name)) %}
{%-   endif %}

Display status of Focus widget in Menu Bar is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.controlcenter
    - name: FocusModes
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
