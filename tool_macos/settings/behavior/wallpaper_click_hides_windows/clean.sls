# vim: ft=sls

{#-
    Resets wallpaper click hides windows behavior to default (enabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.wallpaper_click_hides_windows", "defined") %}

Wallpaper click hides windows behavior is set to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.WindowManager
    - name: EnableStandardClickToShowDesktop
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
