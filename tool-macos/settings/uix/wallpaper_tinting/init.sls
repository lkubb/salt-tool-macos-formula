{#-
    Customizes wallpaper tinting of windows behavior.

    Mind that the actual setting is called "...Reduce...",
    so for consistency, the pillar value is inverted.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.wallpaper_tinting', 'defined') %}

Wallpaper tinting of windows behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleReduceDesktopTinting # in NSGlobalDomain
    - value: {{ False == user.macos.uix.wallpaper_tinting | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

