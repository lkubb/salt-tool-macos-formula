{#-
    Resets Finder Status Bar visibility to default (hidden).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.show_statusbar', 'defined') %}

Finder Status Bar visibility is reset to default (hidden) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: ShowStatusBar
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
