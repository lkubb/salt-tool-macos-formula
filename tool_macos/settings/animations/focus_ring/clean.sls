# vim: ft=sls

{#-
    Resets global focus ring blend-in animation activation status to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.animations", "defined") | selectattr("macos.animations.focus_ring", "defined") %}

Focus ring blend-in animation is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSUseAnimatedFocusRing # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
