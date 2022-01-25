{#-
    Resets infrared sensor activation status.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.ir_receiver is defined %}

Infrared sensor activation status is reset to default:
  macosdefaults.absent:
    # automatic discovery does not work files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.driver.AppleIRController
    - name: DeviceEnabled
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
