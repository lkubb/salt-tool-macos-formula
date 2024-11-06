# vim: ft=sls

{#-
    Resets Finder behavior when a new volume/disk is mounted to default (open on mount).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.finder", "defined") | selectattr("macos.finder.new_window_on_mount", "defined") %}

Finder behavior when a new volume is mounted is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.frameworks.diskimages
    - names:
{%-   for type in ["ro", "rw"] %}
      - auto-open-{{ type }}-root
{%-   endfor %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded

Finder behavior when a new disk is mounted is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: OpenWindowForNewRemovableDisk
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
