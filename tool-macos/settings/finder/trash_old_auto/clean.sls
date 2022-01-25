{#-
    Resets automatic emptying of Trash after 30 days to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.trash_old_auto', 'defined') %}

Automatic emptying of Trash after 30 days is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FXRemoveOldTrashItems
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
