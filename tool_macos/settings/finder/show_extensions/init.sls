{#-
    Customizes display status of file extensions.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.show_extensions', 'defined') %}

Display status of file extensions is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleShowAllExtensions # in NSGlobalDomain
    - value: {{ user.macos.finder.show_extensions | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
