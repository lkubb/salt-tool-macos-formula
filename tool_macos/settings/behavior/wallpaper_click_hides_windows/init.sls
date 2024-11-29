# vim: ft=sls

{#-
    Customizes whether a click on the wallpaper hides open windows
    when not using Stage Manager, revealing the desktop.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.wallpaper_click_hides_windows", "defined") %}

Wallpaper click hides windows behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.WindowManager
    - name: EnableStandardClickToShowDesktop
    - value: {{ user.macos.behavior.wallpaper_click_hides_windows | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
