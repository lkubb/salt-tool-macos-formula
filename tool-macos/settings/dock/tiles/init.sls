{#-
    Customizes dock tiles (items).

    .. warning::

        This currently only supports syncing, not appending.
        Applying this state will delete the previous configuration.

    Values:
        - dict

            * apps: list of items
            * others: list of items
            * sync: true [appending is currently very broken]

    Single item possible values:
        - type: [possibly autodetected if unspecified]

            * app
            * folder
            * url
            * spacer
            * small-spacer
            * flex-spacer

        - label: string [will be automapped if unspecified]
        - path: string [required]

            * /some/absolute/path
            * some://url

        - displayas: string [directories only, default: stack]

            * folder
            * stack

        - showas: string [directories only, default: auto]

            * auto
            * fan
            * grid
            * list

        - arrangeby: string [directories only, default: added]

            * name
            * added
            * modified
            * created
            * kind

    Example:

    .. code-block:: yaml

        tiles:
          sync: true # don't append, make it exactly like specified
          apps:
            - /Applications/TextEdit.app  # paths can be specified, type will be autodetected
            -                             # empty items are small spacers
            - type: file                  # this is the verbose variant for app definition
              path: /Applications/Sublime Text.app
              label: Sublime              # the label will otherwise equal app name without .app
            - small-spacer                # add different spacers with [small-/flex-]spacer
            - path: /Applications/Firefox.app
              label: FF                   # type will be autodetected as above
          others:
            - path: /Users/user/Downloads
              displayas: stack            # stack / folder
              showas: grid                # auto / fan / grid / list
              arrangement: added          # name / added / modified / created / kind
              label: DL                   # the label would be set to Downloads otherwise
              type: directory             # will be autodetected as well
            - spacer
            - /Users/user/Documents       # defaults: stack + auto + added. label: Documents.
            - flex-spacer
            - https://www.github.com      # urls can be added as well
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.dock.tiles', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}
  {#- appending is currently not supported, need to fix macosdefaults.append A LOT #}
  {#- set sync = user.macos.dock.tiles.get('sync', False) #}
  {%- set sync = True %}

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
  {%- if not sync %}
    - skeleton:
        persistent-apps: []
        persistent-others: []
        version: 1
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
