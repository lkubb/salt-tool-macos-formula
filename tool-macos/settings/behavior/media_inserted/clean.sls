{#-
    Resets behavior when inserting a new CD/DVD to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.media_inserted', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Behavior when inserting a new CD/DVD is reset to defaults for user {{ user.name }}:
  macosdefaults.absent_less:
    - domain: com.apple.digihub
    - names:
  {%- if user_settings.blank_cd is not sameas False %}
      - com.apple.digihub.blank.cd.appeared:action
  {%- endif %}
  {%- if user_settings.blank_dvd is not sameas False %}
      - com.apple.digihub.blank.dvd.appeared:action
  {%- endif %}
  {%- if user_settings.music is not sameas False %}
      - com.apple.digihub.cd.music.appeared:action
  {%- endif %}
  {%- if user_settings.picture is not sameas False %}
      - com.apple.digihub.cd.picture.appeared:action
  {%- endif %}
  {%- if user_settings.video is not sameas False %}
      - com.apple.digihub.dvd.video.appeared:action
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
