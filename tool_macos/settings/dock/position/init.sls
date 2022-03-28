{#-
    Customizes dock position.

    Values:
        - string [default: bottom]

            * bottom
            * left
            * right

    References:
        * https://macos-defaults.com/dock/orientation.html
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = ['bottom', 'left', 'right'] %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.position', 'defined') %}

Dock position is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - name: orientation
    - value: {{ user.macos.dock.position if user.macos.dock.position in options else 'bottom' }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
