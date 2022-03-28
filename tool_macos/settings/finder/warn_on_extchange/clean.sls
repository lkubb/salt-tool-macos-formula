{#-
    Resets Finder warning when changing file extensions to default (active).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.warn_on_extchange', 'defined') %}

Finder warning when changing file extensions is reset to default (active) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FXEnableExtensionChangeWarning
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
