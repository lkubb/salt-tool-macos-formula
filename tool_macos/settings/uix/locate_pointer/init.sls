{#-
    Customizes pointer locating by shaking setting.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.locate_pointer', 'defined') %}

Pointer locating by shaking setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: CGDisableCursorLocationMagnification # in NSGlobalDomain
    {#- Mind that the actual setting is called "...Disable...", so the pillar
    value is inverted for consistency. #}
    - value: {{ False == user.macos.uix.locate_pointer | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
