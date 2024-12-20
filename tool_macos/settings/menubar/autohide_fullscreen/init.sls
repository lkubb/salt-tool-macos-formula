# vim: ft=sls

{#-
    Customizes autohide behavior of MacOS Menu Bar (top bar) in fullscreen mode.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.menubar", "defined") | selectattr("macos.menubar.autohide_fullscreen", "defined") %}

Autohide behavior of MacOS Menu Bar in fullscreen mode is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleMenuBarVisibleInFullscreen # in NSGlobalDomain
    {#- Mind that the actual setting is called "...Visible...". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ False == user.macos.menubar.autohide_fullscreen | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
