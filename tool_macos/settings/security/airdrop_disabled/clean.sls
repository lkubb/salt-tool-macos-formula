# vim: ft=sls

{#-
    Resets state of AirDrop to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.security", "defined") | selectattr("macos.security.airdrop", "defined") %}

AirDrop state is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.NetworkBrowser
    - name: DisableAirDrop
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
