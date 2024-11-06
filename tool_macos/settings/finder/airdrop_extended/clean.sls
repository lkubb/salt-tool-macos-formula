# vim: ft=sls

{#-
    Resets AirDrop over Ethernet to default value (disabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.airdrop_extended", "defined") %}

AirDrop over Ethernet is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.NetworkBrowser
    - name: BrowseAllInterfaces
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
