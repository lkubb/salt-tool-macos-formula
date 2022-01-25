{#-
    Resets default system colors for accents and highlights to defaults.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.colors', 'defined') %}

System colors are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in Apple Global Domain
        - AppleAquaColorVariant
        - AppleAccentColor
        - AppleHighlightColor
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
