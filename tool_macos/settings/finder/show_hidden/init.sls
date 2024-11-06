# vim: ft=sls

{#-
    Customizes display status of hidden files.

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.show_hidden", "defined") %}

Display status of hidden files is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: AppleShowAllFiles
    - value: {{ user.macos.finder.show_hidden | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
