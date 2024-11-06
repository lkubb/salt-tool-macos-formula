# vim: ft=sls

{#-
    Resets automatic update settings to defaults (install everything, check daily).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.autoupdate is defined %}
{%-   from tpldir ~ "/map.jinja" import system_settings with context %}

Automatic system update settings are reset to defaults:
  macosdefaults.absent:
    # automatic discovery does not work with that file somehow, needs absolute path
    - domain: /Library/Preferences/com.apple.SoftwareUpdate
    - names:
{%-   for setting, value in system_settings.items() %}
        - {{ setting }}
{%-   endfor %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Automatic App Store update settings are reset to defaults:
  macosdefaults.absent:
    # automatic discovery does not work with that file somehow, needs absolute path
    # (finds another file with PurchasesInflight)
    - domain: /Library/Preferences/com.apple.commerce.plist
    - name: AutoUpdate
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}

