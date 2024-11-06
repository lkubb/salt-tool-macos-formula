# vim: ft=sls

{#-
    Resets global app nap behavior to default (enabled).

    You might need to reboot to apply the settings.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.performance", "defined") | selectattr("macos.performance.app_nap", "defined") %}

Global app nap behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSAppSleepDisabled # global in NSGlobalDomain. as with most of those, can be set per app
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
