{#-
    Customizes alert sound.

    Values:
        - string [default: Tink = Boop in System Preferences]

            * Basso
            * Blow
            * Bottle
            * Frog
            * Funk
            * Glass
            * Hero
            * Morse,
            * Ping
            * Pop
            * Purr
            * Sosumi
            * Submarine
            * Tink

    .. hint::

        Find available ones in ``/System/Library/Sounds/*.aiff``.
        Listen to them via ``afplay /System/Library/Sounds/<name>.aiff``.

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effect_volumechange', 'defined') %}

Alert sound is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.beep.sound # in NSGlobalDomain
    - value: /System/Library/Sounds/{{ user.macos.audio.sound_effect_alert }}.aiff
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
