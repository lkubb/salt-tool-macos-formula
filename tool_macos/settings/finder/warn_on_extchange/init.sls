# vim: ft=sls

{#-
    Customizes Finder warning when changing file extensions.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.warn_on_extchange", "defined") %}

Finder warning when changing file extensions is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: FXEnableExtensionChangeWarning
    - value: {{ user.macos.finder.warn_on_extchange | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
