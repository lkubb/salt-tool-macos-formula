{#-
    Customizes creation of .DS_Store files on network shares and USB devices.

    Values:
        - string [default: none = dump everywhere]
            * none
            * network
            * usb
            * all
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = ['none', 'network', 'usb', 'all'] %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.files', 'defined') | selectattr('macos.files.dsstore_avoid', 'defined') %}
  {%- set opt = user.macos.files.dsstore_avoid if user.macos.files.dsstore_avoid in options else 'none' %}

Creation of .DS_Store files on network shares/USB devices is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.desktopservices
    - names:
        - DSDontWriteNetworkStores:
            - value: {{ opt in ['network', 'all'] }}
        - DSDontWriteUSBStores:
            - value: {{ opt in ['usb', 'all'] }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
