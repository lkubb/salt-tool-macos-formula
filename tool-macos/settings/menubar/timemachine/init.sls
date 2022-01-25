{#-
    Customizes display status of Time Machine widget in Menu Bar.
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.time_machine', 'defined') %}
  {%- set enable = macos.menubar.time_machine | to_bool %}

# Actually adding/removing the widget in part 2 is enough and this entry will be populated
# automatically when adding. It will not be removed though, not sure if that interferes.
Display status of Time Machine widget in Menu Bar is managed for user {{ user.name }} part 1:
  macosdefaults.{{ 'write' if enable else 'absent' }}:
    - domain: com.apple.systemuiserver
    - name: NSStatusItem Visible com.apple.menuextra.TimeMachine
  {%- if enable %}
    - value: True
    - vtype: bool
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded

# cannot call two different methods of the same state module inside
# the same state because of technical limitations
Display status of Time Machine widget in Menu Bar is managed for user {{ user.name }} part 2:
  macosdefaults.{{ 'append' if enable else 'absent_from' }}:
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
