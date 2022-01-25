{#-
    Customizes whether to prefer sending plaintext or richtext messages.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values: string [plain, rich. default: rich]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.format_preferred', 'defined') %}

Format preference for sending mails in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: SendFormat
    - value: {{ 'Plain' if user.macos.mail.format_preferred == 'plain' else 'MIME' }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
