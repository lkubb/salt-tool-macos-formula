{#-
    Customizes behavior when inserting a new CD/DVD.

    Possible values, global or per type:
        * ignore
        * ask
        * finder
        * itunes
        * disk_utility

    .. note::
        There is also the possibility to open an application, which
        is currently not implemented.
        For this, use -int 5. @TODO

    Values:
        - string [one value for all, see above]
        - or dict

            * blank_cd: string [see above]
            * blank_dvd: string [see above]
            * music: string [see above]
            * picture: string [see above]
            * video: string [see above]

    Example:

    .. code-block:: yaml

        media_inserted:
          blank_cd: disk_utility
          blank_dvd: ask
          music: itunes
          pictures: finder
          video: ask

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/cds-dvds.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

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
