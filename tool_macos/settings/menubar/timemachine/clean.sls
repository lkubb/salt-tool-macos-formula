# vim: ft=sls

{#-
    Resets display status of Time Machine widget in Menu Bar to default (hidden).
    Values: bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.menubar", "defined") | selectattr("macos.menubar.time_machine", "defined") %}

Display status of Time Machine widget in Menu Bar is managed for user {{ user.name }} part 1:
  macosdefaults.absent:
    - domain: com.apple.systemuiserver
    - name: NSStatusItem Visible com.apple.menuextra.TimeMachine
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded

Display status of Time Machine widget in Menu Bar is managed for user {{ user.name }} part 2:
  macosdefaults.absent_from:
    - domain: com.apple.systemuiserver
    - names: menuExtras
    - value: /System/Library/CoreServices/Menu Extras/TimeMachine.menu
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
