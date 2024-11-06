# vim: ft=sls

{#-
    Customizes swipe pages touch gesture activation status.

    Values:
        - string [default: two]
          * two
          * three
          * both
        - or false
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require
  - ..multi_helper.three

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.swipe_pages", "defined") %}

Swipe Pages touch gesture activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleEnableSwipeNavigateWithScrolls # in Apple Global Domain
    - value: {{ user.macos.touch.swipe_pages in ["two", "both"] }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

{%- endfor %}
