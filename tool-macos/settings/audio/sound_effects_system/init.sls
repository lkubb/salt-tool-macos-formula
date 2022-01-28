{#-
    Customizes system UI sound effect behavior.

    Values:
        - bool [default: true]

    .. hint::

        This manages system UI sound effects. For all apps, see sound_effects_ui.

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
        * https://discussions.apple.com/thread/253125795
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effects_system', 'defined') %}

System sound effect status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.systemsound
    - name: com.apple.sound.uiaudio.enabled
    - value: {{ user.macos.audio.sound_effects_system | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
