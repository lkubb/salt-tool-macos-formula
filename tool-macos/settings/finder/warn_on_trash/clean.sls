{#-
    Resets Finder warning when emptying trash to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.warn_on_trash', 'defined') %}

Finder warning behavior when emptying trash is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: WarnOnEmptyTrash
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
