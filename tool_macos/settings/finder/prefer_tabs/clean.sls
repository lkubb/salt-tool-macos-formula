{#-
    Resets Finder preference for tabs instead of windows to default (prefer tabs).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.prefer_tabs', 'defined') %}

Finder preference for tabs is reset to default (prefer tabs) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FinderSpawnTab
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
