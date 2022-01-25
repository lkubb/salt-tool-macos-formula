{#-
    Resets Mail.app polling behavior to default (auto).
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.poll', 'defined') %}

Polling behavior of Mail.app is reset to default (auto) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - names:
        - AutoFetch
        - PollTime
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
