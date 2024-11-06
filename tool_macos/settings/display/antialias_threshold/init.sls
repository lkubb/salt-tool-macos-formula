# vim: ft=sls

{#-
    Sets global antialiasing threshold font size.

    Values:
        - int [font size in pixels, default: 4]

    .. note::

        Needs reboot (probably).

    References:
        * https://github.com/kevinSuttle/macOS-Defaults/issues/17
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.display", "defined") | selectattr("macos.display.antialias_threshold", "defined") %}

Custom anti-aliasing threshold font size is set for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleAntiAliasingThreshold # in NSGlobalDomain
    - value: {{ user.macos.display.antialias_threshold }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
