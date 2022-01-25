{#-
    Resets warning when removing files from iCloud Drive to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.warn_on_icloud_remove', 'defined') %}

Warning when removing files from iCloud Drive is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: FXEnableRemoveFromICloudDriveWarning
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
