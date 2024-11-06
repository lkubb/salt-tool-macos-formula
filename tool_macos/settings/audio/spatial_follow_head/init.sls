# vim: ft=sls

{#-
    Customizes "spatial audio follows head movements" setting.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.audio", "defined") | selectattr("macos.audio.spatial_follow_head", "defined") %}

Spatial audio follows head movements setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.Accessibility
    - name: AXSSpatialAudioHeadTracking
    - value: {{ 3 if user.macos.audio.spatial_follow_head else 0 }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded # not sure about that
{%- endfor %}
