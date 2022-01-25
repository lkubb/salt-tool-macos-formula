{#-
    Customizes presence of full POSIX path to current working directory
    in Finder window title.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.title_path', 'defined') %}

Presence of full POSIX path to cwd is reset to default (false) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.frameworks.diskimages
    - name: _FXShowPosixPathInTitle
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
