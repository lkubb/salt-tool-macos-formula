{#-
    Resets whether to highlight collapsed conversations to default.
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.view_conversations', 'defined') %}

Preference for highlight closed conversations in Mail.app is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: HighlightClosedThreads
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
