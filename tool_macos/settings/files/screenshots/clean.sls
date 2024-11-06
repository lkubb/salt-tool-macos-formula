# vim: ft=sls

{#-
    Resets screenshot creation settings to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set formats = ["png", "bmp", "gif", "jpg", "jpeg", "pdf", "tiff"] %}
include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.files", "defined") | selectattr("macos.files.screenshots", "defined") %}

Screenshot settings are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.screencapture
    - names:
{%-   if user.macos.files.screenshots.location is defined %}
      - location
{%-   endif %}
{%-   if user.macos.files.screenshots.basename is defined %}
      - name
{%-   endif %}
{%-   if user.macos.files.screenshots.format is defined %}
      - type
{%-   endif %}
{%-   if user.macos.files.screenshots.include_date is defined %}
      - include-date
{%-   endif %}
{%-   if user.macos.files.screenshots.include_mouse is defined %}
      - showsCursor
{%-   endif %}
{%-   if user.macos.files.screenshots.shadow is defined %}
      - disable-shadow
{%-   endif %}
{%-   if user.macos.files.screenshots.thumbnail is defined %}
      - show-thumbnail
{%-   endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - SystemUIServer was reloaded
{%- endfor %}
