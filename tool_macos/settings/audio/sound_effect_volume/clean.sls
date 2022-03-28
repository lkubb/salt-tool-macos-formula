{#-
    Resets sound effect volume to default (100% of output volume).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effect_volumechange', 'defined') %}

Sound effect volume is reset to default for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.beep.volume # in NSGlobalDomain
    - value: 1.0
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
