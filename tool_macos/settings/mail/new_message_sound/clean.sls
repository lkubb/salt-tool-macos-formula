# vim: ft=sls

{#-
    Resets Mail.app new message alert sound to default (New Message).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.new_message_sound", "defined") %}

New message alert sound of Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: NewMessagesSoundName
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
