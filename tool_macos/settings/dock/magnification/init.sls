{#-
    Customizes dock behavior on hover (magnification).

    Values:
        - dict

          * enabled: bool [default: false]
          * size: int [default: 128]

    Example:

    .. code-block:: yaml

        magnification:
          enabled: true
          size: 64
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.magnification', 'defined') %}

Dock hover magnification is customized for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - names:
        - magnification:
          - value: {{ user.macos.dock.magnification.enabled | to_bool }}
          - vtype: bool
        - largesize:
          - value: {{ user.macos.dock.magnification.size | float }}
          - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
