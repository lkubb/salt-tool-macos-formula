{#-
    Customizes scrolling direction (natural/analog).

    .. note::

        Until I get to finalize macsettings, all of the touch
        settings need a restart. @TODO

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.natural_scrolling', 'defined') %}

Natural scrolling state is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: com.apple.swipescrolldirection # in Apple Global Domain
    - value: {{ user.macos.touch.natural_scrolling | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
