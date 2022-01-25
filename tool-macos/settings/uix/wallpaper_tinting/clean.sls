{#-
    Resets wallpaper tinting of windows behavior to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.wallpaper_tinting', 'defined') %}

Wallpaper tinting of windows behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: AppleReduceDesktopTinting # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

