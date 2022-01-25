{#-
    Resets display status of internal HDD on desktop to default (hidden).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.show_int_hdd', 'defined') %}

Display status of internal HDD on desktop is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: ShowHardDrivesOnDesktop
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
