# vim: ft=sls

{#-
    Resets whether to view messages grouped by conversation by default to default (yes).
    Needs Full Disk Access to work.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.view_conversations", "defined") %}

Preference for conversations in Mail.app is reset to default (true) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ThreadingDefault
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
