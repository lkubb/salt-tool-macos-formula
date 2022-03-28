{#-
    Resets dock autohide behavior to defaults (disabled, time 0.5, delay 0.5).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.autohide', 'defined') %}

Dock autohide behavior is reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - names:
  {%- if user.macos.dock.autohide.enabled is defined %}
        - autohide
  {%- endif %}
  {%- if user.macos.dock.autohide.time is defined %}
        - autohide-time-modifier
  {%- endif %}
  {%- if user.macos.dock.autohide.delay is defined %}
        - autohide-delay
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
