{#-
    Resets global UI sound effect behavior to default (enabled).
    Values: bool [default: true]

    This manages global UI sound effects. For macOS system only, see sound_effects_system.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.sound_effects_ui', 'defined') %}

UI sound effect status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.sound.uiaudio.enabled # in NSGlobalDomain
    - value: 1
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
