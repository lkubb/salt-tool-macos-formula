{#-
    Customizes default Finder List View settings for all folders.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_list', 'defined') %}

Default List View settings are reset to defaults for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - names:
        - StandardViewSettings:ListViewSettings
        - StandardViewSettings:ExtendedListViewSettingsV2
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
