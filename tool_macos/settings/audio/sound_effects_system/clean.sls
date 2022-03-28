{#-
    Resets system UI sound effect behavior to default (enabled).

    This manages system UI sound effects. For all apps, see sound_effects_ui.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effects_system', 'defined') %}

System sound effect status is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.systemsound
    - name: com.apple.sound.uiaudio.enabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
