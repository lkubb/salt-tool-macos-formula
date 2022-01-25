{#-
    Customizes dock tiles (items).
    Values:
      apps: list of items
      others: list of items
      sync: bool [default: true] (sync dock items instead of appending)

      single item:
        type: app / folder / url / spacer / small-spacer / flex-spacer
        name: Something different than default
        path: /Some/absolute/path or some://url
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.tiles', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}
  {%- set sync = user.macos.dock.tiles.get('sync', False) %}

Dock items are customized for user {{ user.name }}:
  macosdefaults.{{ 'write' if sync else 'extend' }}:
    - domain: com.apple.dock
    - names:
  {%- if user_settings.persistent_apps %}
        - persistent-apps:
          - value: {{ user_settings.persistent_apps | json }}
    {%- if sync %}
          - vtype: list
    {%- endif %}
  {%- endif %}
  {%- if user_settings.persistent_others %}
        - persistent-others:
          - value: {{ user_settings.persistent_others | json }}
    {%- if sync %}
          - vtype: list
    {%- endif %}
  {%- endif %}
    # - skeleton:
    #     persistent-apps: []
    #     persistent-others: []
    #     version: 1
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
