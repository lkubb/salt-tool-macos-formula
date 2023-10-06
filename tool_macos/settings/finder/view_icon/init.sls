{#-
    Customizes default Finder Icon View settings for all folders (except Desktop).

    Values:
        - dict

          * arrange: string [default: none]
            - none
            - grid
            - name
            - kind
            - last_opened
            - added
            - modified
            - created
            - size
            - tags
          * size: float [default: 64]
          * spacing: float [default: 54]
          * info: bool [default: false]
          * info_bottom: bool [default: true]
          * text_size: float [default: 12]

    Example:

    .. code-block:: yaml

        view_icon:
          arrange: grid
          size: 54
          spacing: 48
          info: true
          info_bottom: false
          text_size: 11

    References:
        * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_icons', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

# Note: There is also FK_StandardViewSettings:IconViewSettings and FK_DefaultIconViewSettings
#         (as well as TrashViewSettings ~ DesktopViewSettings)
# @TODO
Default Icon View settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - name: StandardViewSettings:IconViewSettings
    - value: {{ user_settings }}
    - skeleton:
        StandardViewSettings:
          IconViewSettings:
            arrangeBy: none
            backgroundColorBlue: 1.0 # real
            backgroundColorGreen: 1.0 # real
            backgroundColorRed: 1.0 # real
            backgroundType: 0 # int
            gridOffsetX: 0.0 # real
            gridOffsetY: 0.0 # real
            gridSpacing: 54.0 # real
            iconSize: 64.0 # real
            labelOnBottom: true
            showIconPreview: true
            showItemInfo: false
            textSize: 12.0 # real
            viewOptionsVersion: 1 # int
          SettingsType: StandardViewSettings
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded

Desktop icon settings cached in ~/Desktop/.DS_Store were flushed for user {{ user.name }}:
  file.absent:
    - name: {{ user.home }}/Desktop/.DS_Store
    - onchanges:
      - Desktop icon settings are customized for {{ user.name }}
{%- endfor %}
