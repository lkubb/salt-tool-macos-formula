{#-
    Customizes volume change feedback sound effect behavior.
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effect_volumechange', 'defined') %}

Volume change feedback sound effect is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.beep.feedback # in NSGlobalDomain
    - value: {{ user.macos.audio.sound_effect_volumechange | to_bool | int }}
    - vtype: int # yup, it's written as int, not bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
