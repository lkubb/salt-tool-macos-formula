{#-
    Resets charging sound (chime) behavior to default (on since 10.13/High Sierra).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.charging_sound', 'defined') %}

Sound when plugging in charging cable is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.PowerChime
    - name: ChimeOnNoHardware
    - user: {{ user.name }}
    - require:
      - System Preferences is not running

  {#- if managed user is current console user (logged in), apply instantly #}
  {%- if user.name == macos._console_user %}
PowerChime.app was reloaded for user {{ user.name }}:
  cmd.run:
    - name: open /System/Library/CoreServices/PowerChime.app
    - runas: {{ user.name }}
    - onchanges:
      - Sound when plugging in charging cable is reset to default for user {{ user.name }}
  {%- endif %}
{%- endfor %}
