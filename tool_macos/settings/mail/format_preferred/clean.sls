{#-
    Resets whether to preference of sent mails to default (rich text).
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.format_preferred', 'defined') %}

Format preference for sending mails in Mail.app is reset to default (rich texxt) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: SendFormat
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
