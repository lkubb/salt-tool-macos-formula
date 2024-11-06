# vim: ft=sls

{#-
    Resets creation settings of .DS_Store files on network shares and USB devices
    to defaults (enabled everywhere).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = ["none", "network", "usb", "all"] %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.files", "defined") | selectattr("macos.files.dsstore_avoid", "defined") %}

Creation of .DS_Store files on network shares/USB devices is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.desktopservices
    - names:
        - DSDontWriteNetworkStores
        - DSDontWriteUSBStores
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
