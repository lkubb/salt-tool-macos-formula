{#-
    Customizes cursor blinking on/off periods. False to disable. Else specify on/off periods.

    Values:
        - false to disable
        - or dict

            * on: float [default: ?]
            * off: float [default: ?]

    Example:

    .. code-block:: yaml

        cursor_blinking:
          on: 2.5
          off: .5
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.cursor_blinking', 'defined') %}
  {%- set periods = user.macos.animations.cursor_blinking %}
  {%- if periods is sameas False %}
    {%- set periods = {'on': 1000000, 'off': 1000} %}
  {%- endif %}
Cursor blinking behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - names: # in NSGlobalDomain
      - NSTextInsertionPointBlinkPeriodOn:
        - value: {{ periods.on | float }}
      - NSTextInsertionPointBlinkPeriodOff:
        - value: {{ periods.off | float }}
    - vtype: real
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
