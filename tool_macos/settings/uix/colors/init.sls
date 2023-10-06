{#-
    Customizes default system colors for accents and highlights.

    .. note::

        This currently does not support custom highlight colors (not allowed for accent colors).

    Values:
        - dict

          * accent: string [default: multi]
            - multi
            - blue
            - purple
            - pink
            - red
            - orange
            - yellow
            - green
            - graphite

          * highlight: string [default: accent_color]
            - accent_color
            - blue
            - purple
            - pink
            - red
            - orange
            - yellow
            - green
            - graphite
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.colors', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

  {%- if user_settings.highlight is sameas False or user_settings.accent is sameas False %}
  {#- this is the case for 'multi' accent setting and 'accent_color' highlight setting #}

System colors are managed (default) for user {{ user.name }}:
  macosdefaults.absent:
    - names: # in Apple Global Domain
    {%- if user_settings.accent is sameas False %}
        - AppleAccentColor
    {%- endif %}
    {%- if user_settings.highlight is sameas False %}
        - AppleHighlightColor
    {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
  {%- endif %}

System colors are managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in Apple Global Domain
        - AppleAquaColorVariant:
            - value: {{ user_settings.aqua_variant | int }}
            - vtype: int
  {%- if user_settings.accent is not sameas False %}
        - AppleAccentColor:
            - value: {{ user_settings.accent | int }}
            - vtype: int
  {%- endif %}
  {%- if user_settings.highlight is not sameas False %}
        - AppleHighlightColor:
            - value: {{ user_settings.highlight }}
            - vtype: string
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
