{#-
    Customizes global UI sound effect behavior.

    Values:
        - bool [default: true]

    .. hint::

        This manages global UI sound effects. For macOS system only, see sound_effects_system.

    References:
        * https://superuser.com/questions/278537/disable-sounds-in-10-5-and-10-6
        * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
        * https://discussions.apple.com/thread/253125795
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effects_ui', 'defined') %}

UI sound effect status is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.uiaudio.enabled # in NSGlobalDomain
    - value: {{ user.macos.audio.sound_effects_ui | to_bool | int }}
    - vtype: int # yup, it's written as int, not bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
