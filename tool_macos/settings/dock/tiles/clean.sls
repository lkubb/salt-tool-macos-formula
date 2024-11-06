# vim: ft=sls

{#-
    Removes all dock tiles (items) added by tool-macos
    (depending on current pillar configuration).

    This will probably currently not work since the
    parsed values are different from what dock will make them into.
    @FIXME
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.tiles", "defined") %}
  {%- from tpldir ~ "/map.jinja" import user_settings with context %}

Automatically added dock items are removed for user {{ user.name }}:
  macosdefaults.absent_from:
    - domain: com.apple.dock
    - names:
  {%- if user_settings.persistent_apps %}
        - persistent-apps:
          - value: {{ user_settings.persistent_apps | json }}
  {%- endif %}
  {%- if user_settings.persistent_others %}
        - persistent-others:
          - value: {{ user_settings.persistent_others | json }}
  {%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
