{#-
    Customizes spaces separation of different displays.

    .. note::

        Needs a logout to apply.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.spaces_span_displays', 'defined') %}

Spaces separation of different displays is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.spaces
    - name: spans-displays
    - value: {{ user.macos.behavior.spaces_span_displays | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
