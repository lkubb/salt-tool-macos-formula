{#-
    Resets shortcut to send mails to default.

    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.shortcut_send', 'defined') %}

Custom shortcut to send mails in Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent_less:
    - domain: com.apple.mail
    - name: NSUserKeyEquivalents:Send
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
