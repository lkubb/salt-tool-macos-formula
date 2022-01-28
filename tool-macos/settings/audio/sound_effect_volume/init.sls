{#-
    Customizes sound effect volume (in parts of current output volume).

    Values:
        - float [default: 1]

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/sound.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effect_volumechange', 'defined') %}

Sound effect volume is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.beep.volume # in NSGlobalDomain
    - value: {{ (2.718281828459045**(-(1-user.macos.audio.sound_effect_volume))) | round(7) | float }}
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
