# vim: ft=sls

{#-
    Customizes transparency in menus and windows setting.

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.transparency_reduced", "defined") %}

Transparency in menus and windows setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.universalaccess
    - name: reduceTransparency
    - value: {{ user.macos.uix.transparency_reduced | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
