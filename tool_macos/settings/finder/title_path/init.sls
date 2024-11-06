# vim: ft=sls

{#-
    Customizes presence of full POSIX path to current working directory
    in Finder window title.

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.title_path", "defined") %}

Presence of full POSIX path to cwd is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.frameworks.diskimages
    - name: _FXShowPosixPathInTitle
    - value: {{ user.macos.finder.title_path | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
