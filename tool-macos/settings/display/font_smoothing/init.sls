{#-
    Sets global font smoothing behavior.

    Values:
      font_smoothing: disabled(0) / light(1) / medium(2) / heavy(3)
          [default: 2 since 10.11/El Capitan, before 3]

    Needs reboot (probably).

    References:
      https://tonsky.me/blog/monitors/#turn-off-font-smoothing
      https://github.com/bouncetechnologies/Font-Smoothing-Adjuster
      https://github.com/kevinSuttle/macOS-Defaults/issues/17
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- set options = {
  'disabled': 0,
  'light': 1,
  'medium': 2,
  'heavy': 3,
  'default': 2
  } %}

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.font_smoothing', 'defined') %}
  {%- set value = user.macos.display.font_smoothing if user.macos.display.font_smoothing is integer
             else options.get(user.macos.display.font_smoothing, 2) %}

Global font smoothing is set to custom value for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleFontSmoothing # in NSGlobalDomain
    - host: current # needs to be set with defaults -currentHost
    - value: {{ value }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
