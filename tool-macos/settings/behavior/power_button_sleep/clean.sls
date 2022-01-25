{#-
    Resets behavior when pressing the power button to default (put system to sleep).
    Might need a reboot to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.power_button_sleep', 'defined') %}

Behavior when pressing the power button is reset to default (sleep) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.loginwindow
    - name: PowerButtonSleepsSystem
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
