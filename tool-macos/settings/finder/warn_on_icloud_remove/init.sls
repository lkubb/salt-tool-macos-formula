{#-
    Customizes warning when removing files from iCloud Drive.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.warn_on_icloud_remove', 'defined') %}

Warning when removing files from iCloud Drive is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: FXEnableRemoveFromICloudDriveWarning
    - value: {{ user.macos.finder.warn_on_icloud_remove | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
