{#-
    Resets dock behavior regarding scrolling over tiles to default (nothing).
    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.scroll_to_open', 'defined') %}

Dock behavior when scrolling over tiles is reset to default (nothing) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.dock
    - name: scroll-to-open
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
