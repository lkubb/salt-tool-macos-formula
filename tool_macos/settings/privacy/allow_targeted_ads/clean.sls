# vim: ft=sls

{#-
    Resets state of targeted ads to default (enabled - wtf).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.privacy", "defined") | selectattr("macos.privacy.allow_targeted_ads", "defined") %}

State of targeted ads is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.AdLib
    - name: allowApplePersonalizedAdvertising
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - adprivacyd was reloaded # maybe?
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
