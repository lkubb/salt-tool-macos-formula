# vim: ft=sls

{#-
    Customizes availability of Live Text (select text in pictures).

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.live_text", "defined") %}

Availability of Live Text is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleLiveTextEnabled # in NSGlobalDomain
    - value: {{ user.macos.uix.live_text | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
