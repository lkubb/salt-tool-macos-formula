{#-
    Customizes whether to quote the original mail when sending a reply.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    The other setting ("Increase quote level") is mapped to SupressQuoteBarsInComposeWindows INVERTED.
    @TODO

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.respond_with_quote', 'defined') %}

Quote original message setting in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: ReplyQuotesOriginal
    - value: {{ user.macos.mail.respond_with_quote | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
