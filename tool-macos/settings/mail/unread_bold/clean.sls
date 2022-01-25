{#-
    Resets whether to display unread messages in bold font to default (false).
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.unread_bold', 'defined') %}

Display unread messages in bold font setting is reset to default (false) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: ShouldShowUnreadMessagesInBold
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
