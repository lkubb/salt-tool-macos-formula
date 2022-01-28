{#-
    Customizes screenshot creation settings.

    Values:
        - dict

            * basename: string [default: Screenshot]
            * format: string [default: png]
                - png
                - bmp
                - gif
                - jp(e)g
                - pdf
                - tiff

            * include_date: bool [default: true]
            * location: string [default: $HOME/Desktop]
            * shadow: bool [default: true]

    Example:

    .. code-block:: yaml

        screenshots:
          basename: s1(k
          format: bmp
          include_date: true
          location: /Users/h4xx0r/screenshots
          shadow: false

    References:
        * https://ss64.com/osx/screencapture.html
        * https://github.com/joeyhoer/starter/blob/master/apps/screenshot.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- set formats = ['png', 'bmp', 'gif', 'jpg', 'jpeg', 'pdf', 'tiff'] %}
include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.files', 'defined') | selectattr('macos.files.screenshots', 'defined') %}

Screenshot settings are managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.screencapture
    - names:
  {%- if user.macos.files.screenshots.basename is defined %}
      - name:
          - value: {{ user.macos.files.screenshots.basename }}
          - vtype: string
  {%- endif %}
  {%- if user.macos.files.screenshots.format is defined %}
      - type:
          - value: {{ user.macos.files.screenshots.format if user.macos.files.screenshots.format in formats else 'png' }}
          - vtype: string
  {%- endif %}
  {%- if user.macos.files.screenshots.include_date is defined %}
      - include-date:
          - value: {{ user.macos.files.screenshots.include_date | to_bool }}
          - vtype: bool
  {%- endif %}
  {%- if user.macos.files.screenshots.include_mouse is defined %}
      - showsCursor:
          - value: {{ user.macos.files.screenshots.include_mouse | to_bool }}
          - vtype: bool
  {%- endif %}
  {%- if user.macos.files.screenshots.shadow is defined %}
      - disable-shadow:
          - value: {{ user.macos.files.screenshots.shadow | to_bool }}
          - vtype: bool
  {%- endif %}
  {%- if user.macos.files.screenshots.thumbnail is defined %}
      - show-thumbnail:
          - value: {{ user.macos.files.screenshots.thumbnail | to_bool }}
          - vtype: bool
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
