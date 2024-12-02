# vim: ft=sls

{#-
    Resets searches sharing status.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.privacy", "defined") | selectattr("macos.privacy.searches_share", "defined") %}

Searches sharing status is reset to default (unset) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.assistant.support
    - name: Search Queries Data Sharing Status
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
