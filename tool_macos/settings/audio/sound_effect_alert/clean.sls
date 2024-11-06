# vim: ft=sls

{#-
    Resets alert sound to default (Tink = Boop).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.audio", "defined") | selectattr("macos.audio.sound_effect_volumechange", "defined") %}

Alert sound is reset to default (Tink/Boop) for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.beep.sound # in NSGlobalDomain
    - value: /System/Library/Sounds/Tink.aiff
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
