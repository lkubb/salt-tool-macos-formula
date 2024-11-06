# vim: ft=sls

{#-
    Resets whether to include related messages in conversation view to default (enabled?).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.include_related", "defined") %}

Include related messages in conversation view setting in Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ConversationViewSpansMailboxes
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
