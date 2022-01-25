{#-
    Resets cursor blinking on/off periods to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.cursor_blinking', 'defined') %}

Cursor blinking behavior is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in NSGlobalDomain
      - NSTextInsertionPointBlinkPeriodOn
      - NSTextInsertionPointBlinkPeriodOff
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
