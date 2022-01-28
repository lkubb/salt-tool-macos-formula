{#-
    Customizes AirDrop over Ethernet (and on unsupported old Macs).

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.airdrop_extended', 'defined') %}

AirDrop over Ethernet is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.NetworkBrowser
    - name: BrowseAllInterfaces
    - value: {{ user.macos.finder.airdrop_extended | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
