# vim: ft=sls

{#-
    Resets activation state of smart quotes to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.textinput", "defined") | selectattr("macos.textinput.smart_quotes", "defined") %}

Activation of smart quotes is reset to default (enabled) for {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticQuoteSubstitutionEnabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
