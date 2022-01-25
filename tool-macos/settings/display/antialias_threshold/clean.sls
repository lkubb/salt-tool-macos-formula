{#-
    Resets global antialiasing threshold font size to default.

    Needs reboot (probably).

    References:
      https://github.com/kevinSuttle/macOS-Defaults/issues/17
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.antialias_threshold', 'defined') %}

Global anti-aliasing threshold font size is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleAntiAliasingThreshold # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
