# vim: ft=sls

{#-
    Resets all power settings to default.

    Note that this **resets all power settings to default**
    if just a single one is managed. All settings include those
    not explicitly managed, unlike most other states in this formula.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._require

{%- if macos.power is defined %}

Power settings are restored to defaults:
  cmd.run:
    - name: pmset restoredefaults
    - runas: root
    - require:
      - System Preferences is not running
{%- endif %}
