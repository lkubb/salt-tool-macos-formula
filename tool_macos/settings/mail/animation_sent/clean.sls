# vim: ft=sls

{#-
    Resets activation status of sent animation to default (enabled).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.animation_sent", "defined") %}

Activation status of sent animation in Mail.app is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: DisableSendAnimations
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
