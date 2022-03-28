{#-
    Resets volume change feedback sound effect behavior to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effect_volumechange', 'defined') %}

Volume change feedback sound effect is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: com.apple.sound.beep.feedback # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
