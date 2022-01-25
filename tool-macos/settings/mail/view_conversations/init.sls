{#-
    Customizes whether to view messages grouped by conversation by default.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.view_conversations', 'defined') %}

Preference for conversations in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: ThreadingDefault
    - value: {{ user.macos.mail.view_conversations | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
