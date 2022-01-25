{#-
    Customizes behavior when inserting a new CD/DVD.

    Values, for each type:
      ignore / ask / finder / itunes / disk_utility [application 5 @TODO]

    Values: string [to set all, see above]
        OR
      blank_cd: string [see above]
      blank_dvd: string [see above]
      music: string [see above]
      picture: string [see above]
      video: string [see above]

    References:
      https://github.com/joeyhoer/starter/blob/master/system/cds-dvds.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.media_inserted', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Behavior when inserting a new CD/DVD is managed for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.digihub
    - names:
  {%- if user_settings.blank_cd is not sameas False %}
      - com.apple.digihub.blank.cd.appeared:action:
          - value: {{ user_settings.blank_cd | int }}
  {%- endif %}
  {%- if user_settings.blank_dvd is not sameas False %}
      - com.apple.digihub.blank.dvd.appeared:action:
          - value: {{ user_settings.blank_dvd | int }}
  {%- endif %}
  {%- if user_settings.music is not sameas False %}
      - com.apple.digihub.cd.music.appeared:action:
          - value: {{ user_settings.music | int }}
  {%- endif %}
  {%- if user_settings.picture is not sameas False %}
      - com.apple.digihub.cd.picture.appeared:action:
          - value: {{ user_settings.picture | int }}
  {%- endif %}
  {%- if user_settings.video is not sameas False %}
      - com.apple.digihub.dvd.video.appeared:action:
          - value: {{ user_settings.video | int }}
  {%- endif %}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
