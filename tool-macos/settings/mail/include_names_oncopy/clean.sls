{#-
    Resets whether to include recipient names when copying mail addresses to default (yes).
    Needs Full Disk Access to work.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.include_names_oncopy', 'defined') %}

Setting to include names on address copy in Mail.app is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.mail
    - name: AddressesIncludeNameOnPasteboard
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
