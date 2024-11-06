# vim: ft=sls

{#-
    Resets requirement of password after entering sleep/screensaver to defaults (enabled immediately).
    You might need to reboot to apply.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.security", "defined") | selectattr("macos.security.password_after_sleep", "defined") %}

Requirement of password after entering sleep is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.screensaver
    - names:
{%-   if user.macos.security.password_after_sleep.require is defined %}
        - askForPassword
{%-   endif %}
{%-   if user.macos.security.password_after_sleep.delay is defined %}
        - askForPasswordDelay
{%-   endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
