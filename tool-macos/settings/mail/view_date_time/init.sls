{#-
    Customizes whether to display date and time in overview.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.view_date_time', 'defined') %}

Display status of date and time in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: MessageListShowDateTime
    - value: {{ user.macos.mail.view_date_time | to_bool | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
