{#-
    Customizes screensaver behavior.

    Values:
      after: int  [active after x seconds] [default: 1200 / 20min. 0 to disable]
      clock: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.performance', 'defined') | selectattr('macos.performance.screensaver', 'defined') %}

Screensaver behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.screensaver
    - names:
  {%- if user.macos.performance.screensaver.after is defined %}
        - idleTime:
            - value: {{ user.macos.performance.screensaver.after | int }}
            - vtype: int
  {%- endif %}
  {%- if user.macos.performance.screensaver.clock is defined %}
        - showClock:
            - value: {{ user.macos.performance.screensaver.clock | to_bool }}
            - vtype: bool
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
