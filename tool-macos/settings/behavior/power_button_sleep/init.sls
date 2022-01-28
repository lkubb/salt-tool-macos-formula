{#-
    Customizes behavior when pressing the power button.

    .. note:

        Might need a reboot to apply.

    Values:
        - bool [default: true]

            * true = put system to sleep
            * false = show prompt
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.power_button_sleep', 'defined') %}

Behavior when pressing the power button is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.loginwindow
    - name: PowerButtonSleepsSystem
    - value: {{ user.macos.behavior.power_button_sleep | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
