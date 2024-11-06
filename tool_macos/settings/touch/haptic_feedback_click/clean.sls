# vim: ft=sls

{#-
    Resets click feedback to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.haptic_feedback_click", "defined") %}

Click feedback (actuation) is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: ActuationStrength
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
