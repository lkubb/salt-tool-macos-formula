{#-
    Customizes dock behavior on hover (magnification).
    Values:
      enabled: bool [default: false]
      size: int [default: 128]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

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
