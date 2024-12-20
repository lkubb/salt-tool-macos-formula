# vim: ft=sls

{#-
    Resets measurement units to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.localization", "defined") | selectattr("macos.localization.measurements", "defined") %}

Measurement units are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in NSGlobalDomain
        - AppleMeasurementUnits
        - AppleMetricUnits
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
