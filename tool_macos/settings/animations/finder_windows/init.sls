# vim: ft=sls

{#-
    Customizes Finder window animation activation status.
    This mostly affects the File Info dialog.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.animations", "defined") | selectattr("macos.animations.finder_windows", "defined") %}

Finder window animation activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: DisableAllAnimations
    {#- Mind that the actual setting is called "Disable...",
    so the pillar value is inverted for consistency. #}
    - value: {{ False == user.macos.animations.finder_windows | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
