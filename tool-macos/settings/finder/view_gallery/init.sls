{#-
    Customizes default Finder Gallery View settings for all folders.

    Values:
        - dict

            * arrange: string [default: name]

                - none
                - name
                - kind
                - last_opened
                - added
                - modified
                - created
                - size
                - tags

            * icon_size: float [default: 48]
            * preview: bool [default: true]
            * preview_pane: bool [default: true]
            * titles: bool [default: false]

    Example:

    .. code-block:: yaml

        view_gallery:
          arrange: kind
          icon_size: 32
          titles: true
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_gallery', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings, user_options with context %}

Default Gallery View settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - names:
  {%- if user_settings %}
        - StandardViewSettings:ColumnViewSettings:
            - value: {{ user_settings }}
            - skeleton:
                StandardViewSettings:
                  GalleryViewSettings:
                    arrangeBy: name
                    iconSize: 48 # real
                    showIconPreview: true
                    viewOptionsVersion: 1 # int
                  SettingsType: StandardViewSettings
  {%- endif %}
  {%- if user_options %}
        - StandardViewOptions:ColumnViewOptions:
            - value: {{ user_options }}
            - skeleton:
                StandardViewOptions:
                  GalleryViewOptions:
                    ShowPreviewPane: true
                    ShowTitles: false
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
