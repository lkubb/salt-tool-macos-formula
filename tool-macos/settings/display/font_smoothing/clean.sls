{#-
    Resets global font smoothing behavior to default.

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

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.font_smoothing', 'defined') %}

Global font smoothing is reset to default value (medium) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleFontSmoothing # in NSGlobalDomain
    - host: current # needs to be set with defaults -currentHost
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
