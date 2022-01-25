{#-
    Resets sending read receipts in Messages.app to default.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.apps', 'defined') |
    selectattr('macos.apps.messages', 'defined') |
    selectattr('macos.apps.messages.read_receipts', 'defined') %}

Read receipts are managed for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.imagent
    - name: Setting.EnableReadReceipts
    - user: {{ user.name }}
    - require:
      - Messages is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
