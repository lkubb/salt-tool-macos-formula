{#-
    Resets default Finder Column View settings for all folders to defaults.

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_column', 'defined') %}

Default Icon View settings are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: StandardViewOptions:ColumnViewOptions
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
