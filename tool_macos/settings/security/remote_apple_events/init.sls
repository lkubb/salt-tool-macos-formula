# vim: ft=sls

{#-
    Customizes activation state of Remote Apple Events.

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.remote_apple_events is defined %}
{%-   set m = macos.security.remote_apple_events %}

Activation state of Remote Apple Events is managed:
  cmd.run:
    - name: /usr/sbin/systemsetup setremoteappleevents {{ "on" if m else "off" }}
    - runas: root
    - unless:
        - /usr/sbin/systemsetup getremoteappleevents | grep 'Remote Apple Events: {{ "On" if m else "Off" }}'
    - require:
      - System Preferences is not running
{%- endif %}
