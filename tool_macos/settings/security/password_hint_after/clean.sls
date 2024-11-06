# vim: ft=sls

{#-
    Resets number of tries until display of password hint to default.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.security", "defined") | selectattr("macos.security.password_hint_after", "defined") %}

Number of tries before password hint are reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: RetriesUntilHint # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
