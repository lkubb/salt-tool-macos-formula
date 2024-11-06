# vim: ft=sls

{#-
    Resets new Finder window default path to default (recent files).

    Values: string
        [computer / volume / home / desktop / documents / recent / </my/custom/path>]

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.home", "defined") %}

New Finder window default path is reset to default (recent files) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - names:
        - NewWindowTarget
        - NewWindowTargetPath
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
