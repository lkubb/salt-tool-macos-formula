# vim: ft=sls

{#-
    Resets availability of Live Text (select text in pictures) to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.live_text", "defined") %}

Availability of Live Text is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleLiveTextEnabled # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
