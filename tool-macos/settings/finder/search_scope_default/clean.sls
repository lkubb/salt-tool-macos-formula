{#-
    Resets default search scope to default (This Mac).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.search_scope_default', 'defined') %}

Finder default search scope is reset to default (This Mac) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FXDefaultSearchScope
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
