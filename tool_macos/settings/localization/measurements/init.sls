{#-
    Customizes measurement units.

    Values:
        - string

            * metric
            * US
            * UK
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.localization', 'defined') | selectattr('macos.localization.measurements', 'defined') %}
  {#- yup, UK units are seen as metric #}
  {%- set metric = user.macos.localization.measurements in ['metric', 'UK'] %}
  {%- set units = "Inches" if user.macos.localization.measurements in ['UK', 'US'] else "Centimeters" %}

Measurement units are managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in NSGlobalDomain
        - AppleMeasurementUnits:
            - value: {{ units }}
            - vtype: string
        - AppleMetricUnits:
            - value: {{ metric }}
            - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
