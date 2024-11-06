# vim: ft=sls

{#-
    Resets activation status of multicast DNS advertisements to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.mdns is defined %}

Activation status of multicast DNS advertisements is reset to default (enabled):
  macosdefaults.absent:
    - domain: /Library/Preferences/com.apple.mDNSResponder.plist
    - name: NoMulticastAdvertisements
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - mDNSResponder was reloaded
{%- endif %}
