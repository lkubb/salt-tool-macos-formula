{#-
    Resets autohide behavior of MacOS Menu Bar (top bar) on Desktop to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.autohide_desktop', 'defined') %}

Autohide behavior of MacOS Menu Bar on Desktop is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: _HIHideMenuBar # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
