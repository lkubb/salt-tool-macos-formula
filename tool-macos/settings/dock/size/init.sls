{#-
    Customizes dock tile (icon) size and mutability.

    Values:
        - dict

            * immutable: bool [default: false]
            * tiles: int [default: 48]

    References:
        * https://macos-defaults.com/dock/tilesize.html
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.size', 'defined') %}

Dock tile (icon) size is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - names:
{%- if user.macos.dock.size.tiles is defined %}
      - tilesize:
        - value: {{ user.macos.dock.size.tiles | int }}
        - vtype: int
{%- endif %}
{%- if user.macos.dock.size.immutable is defined %}
      - size-immutable:
        - value: {{ user.macos.dock.size.immutable | to_bool }}
        - vtype: bool
{%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
