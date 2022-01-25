{#-
    Resets motion reducing mode to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.motion_reduced', 'defined') %}

Motion reducing mode is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.universalaccess
    - name: reduceMotion
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
