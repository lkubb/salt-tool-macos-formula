# vim: ft=sls

{#-
    Resets conversation sorting order to default (descending).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.conv_most_recent_top", "defined") %}

Message sorting for conversations in Mail.app setting is reset to default (desc) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ConversationViewSortDescending
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
