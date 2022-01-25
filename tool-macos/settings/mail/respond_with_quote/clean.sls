{#-
    Resets whether to quote the original mail when sending a reply to default (true).
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.respond_with_quote', 'defined') %}

Quote original message setting in Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ReplyQuotesOriginal
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
