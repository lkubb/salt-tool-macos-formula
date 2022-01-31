{#-
    Customizes desktop icons.

    Values:
        - dict

          * show: bool [default: true]
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

          * size: float [default: 64.0]
          * spacing: float [default: 54.0]
          * info: bool [default: false]
          * info_bottom: bool [default: true]
          * text_size: float [default: 12]

    Example:

    .. code-block:: yaml

      desktop_icons:
        show: true
        arrange: grid
        size: 54
        spacing: 40
        text_size: 11

    References:
        * https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.desktop_icons', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

  {%- if user.macos.finder.desktop_icons.show is defined %}

Desktop icon visibility is customized for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: CreateDesktop
    - value: {{ user.macos.finder.desktop_icons.show | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
  {%- endif %}

  {%- if user.macos.finder.desktop_icons.keys() - 'show' | list %}

Desktop icon settings are customized for user {{ user.name }}:
  macosdefaults.update:
    - domain: com.apple.finder
    - name: DesktopViewSettings:IconViewSettings
    - value: {{ user_settings }}
    - skeleton:
        DesktopViewSettings:
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
      - Desktop icon settings are customized for user {{ user.name }}
  {%- endif %}
{%- endfor %}
