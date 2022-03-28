{#-
    Customizes display status of internal HDD on desktop.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.show_int_hdd', 'defined') %}

Display status of internal HDD on desktop is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: ShowHardDrivesOnDesktop
    - value: {{ user.macos.finder.show_int_hdd | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
