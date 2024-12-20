# vim: ft=sls

{#-
    Customizes global preference for tabs.

    Values:
        - string [default: fullscreen]

          * manual
          * fullscreen
          * always
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set options = ["manual", "fullscreen", "always"] %}

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.tab_preference", "defined") %}
{%-   set u = user.macos.behavior.tab_preference %}

Global preference for tabs is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleWindowTabbingMode # in NSGlobalDomain
    - value: {{ u if u in options else "fullscreen" }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
