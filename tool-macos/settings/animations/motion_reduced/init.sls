{#-
    Customizes motion reducing mode.
    This e.g. changes the animation when swiping between spaces to fade/blend.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.motion_reduced', 'defined') %}

Motion reducing mode is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.universalaccess
    - name: reduceMotion
    - value: {{ user.macos.animations.motion_reduced | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
