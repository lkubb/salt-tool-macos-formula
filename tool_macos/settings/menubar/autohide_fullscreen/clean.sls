{#-
    Resets autohide behavior of MacOS Menu Bar (top bar) in fullscreen mode to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.menubar', 'defined') | selectattr('macos.menubar.autohide_fullscreen', 'defined') %}

Autohide behavior of MacOS Menu Bar in fullscreen mode is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleMenuBarVisibleInFullscreen # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
