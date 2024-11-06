# vim: ft=sls

{#-
    Resets whether to mark all messages as read when viewing conversation to default (false).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.conv_mark_all_read", "defined") %}

Mark all read setting for conversations in Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ConversationViewMarkAllAsRead
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
