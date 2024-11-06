# vim: ft=sls

{#-
    Customizes global focus ring blend-in animation activation status.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.animations", "defined") | selectattr("macos.animations.focus_ring", "defined") %}

Focus ring blend-in animation is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSUseAnimatedFocusRing # in NSGlobalDomain
    - value: {{ user.macos.animations.focus_ring | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
