# vim: ft=sls

{#-
    Resets whether to display message size in overview to default (false).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.view_message_size", "defined") %}

Display status of message size in Mail.app is reset to default (false) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: MessageListShowSize
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
