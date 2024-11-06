# vim: ft=sls

{#-
    Customizes Infrared sensor activation status.

    This has not been a thing in a long time.

    https://en.wikipedia.org/wiki/Apple_Remote#Compatibility

    Values: bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.ir_receiver is defined %}

Infrared sensor activation status is managed:
  macosdefaults.write:
    # automatic discovery does not work files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.driver.AppleIRController
    - name: DeviceEnabled
    - value: {{ macos.security.ir_receiver | int }}
    - vtype: int
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
