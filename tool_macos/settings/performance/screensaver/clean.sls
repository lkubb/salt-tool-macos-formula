# vim: ft=sls

{#-
    Resets screensaver behavior to defaults (after 20 min, no clock).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.performance", "defined") | selectattr("macos.performance.screensaver", "defined") %}

Screensaver behavior is reset to defaults (20min/no clock) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.screensaver
    - names:
  {%- if user.macos.performance.screensaver.after is defined %}
        - idleTime
  {%- endif %}
  {%- if user.macos.performance.screensaver.clock is defined %}
        - showClock
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
