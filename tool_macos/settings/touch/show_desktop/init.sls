# vim: ft=sls

{#-
    Customizes Show Desktop touch gesture activation status.

    Values:
        - bool [default: true]

    .. note::

        Pinch gestures need to be active for Launchpad or Show Desktop actions.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.pinch

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.show_desktop", "defined") %}

Show Desktop touch gesture activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: showDesktopGestureEnabled
    - value: {{ user.macos.touch.show_desktop | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
