{#-
    Customizes default Finder Icon View settings for all folders (except Desktop).

    Values:
      arrange: string [default: none]
          none, grid, name, kind, last_opened, added, modified, created, size, tags
      size: real [default: 64.0]
      spacing: real [default: 54.0]
      info: bool [default: false]
      info_bottom: bool [default: true]
      text_size: real [default: 12]

    Note: There is also FK_StandardViewSettings:IconViewSettings and FK_DefaultIconViewSettings
          (as well as TrashViewSettings ~ DesktopViewSettings)

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.view_icons', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

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
