{#-
    Resets display behavior of Clock widget in Menu Bar to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.clock', 'defined') %}

Display behavior of Clock widget is reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.menuextra.clock
    - names:
  {%- if user.macos.menubar.clock.analog is defined %}
        - IsAnalog
  {%- endif %}
  {%- if user.macos.menubar.clock.flash_seconds is defined %}
        - FlashDateSeparators
  {%- endif %}
  {%- if user.macos.menubar.clock.format is defined %}
        - DateFormat
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
