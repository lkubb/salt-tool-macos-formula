# vim: ft=sls

{#-
    Resets "spatial audio follows head movements" setting to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.audio", "defined") | selectattr("macos.audio.spatial_follow_head", "defined") %}

Spatial audio follows head movements setting is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.Accessibility
    - name: AXSSpatialAudioHeadTracking
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
