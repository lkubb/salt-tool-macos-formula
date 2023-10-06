{#-
    Customizes default Finder Column View settings for all folders.

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
          * col_width: int [default: 245]
          * folder_arrow: bool [default: true]
          * icons: bool [default: true]
          * preview: bool [default: true]
          * preview_disclosure: bool [default: true]
          * shared_arrange: string [default: none]
            - none
            - name
            - kind
            - last_opened
            - added
            - modified
            - created
            - size
            - tags
          * text_size: int [default: 13]
          * thumbnails: bool [default: true]

    Example:

    .. code-block:: yaml

        view_column:
          arrange: added
          col_width: 200
          icons: false
          shared_arrange: last_opened

    References:
        * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_column', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Default Column View settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - name: StandardViewOptions:ColumnViewOptions
    - value: {{ user_settings }}
    - skeleton:
        StandardViewOptions:
          ColumnViewOptions:
            ArrangeBy: dnam
            ColumnShowFolderArrow: true
            ColumnShowIcons: true
            ColumnWidth: 245 # int
            FontSize: 13 # int
            PreviewDisclosureState: true
            SharedArrangeBy: kipl
            ShowIconThumbnails: true
            ShowPreview: true
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
