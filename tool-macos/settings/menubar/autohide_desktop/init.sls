{#-
    Customizes autohide behavior of MacOS Menu Bar (top bar) on Desktop.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.autohide_desktop', 'defined') %}

Autohide behavior of MacOS Menu Bar on Desktop is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: _HIHideMenuBar # in NSGlobalDomain
    - value: {{ user.macos.menubar.autohide_desktop | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
