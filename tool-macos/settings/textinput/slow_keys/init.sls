{#-
    Customizes state of slow keys accessibility feature (delay before
    accepting keypresses).

    Needs Full Disk Access.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.slow_keys', 'defined') %}

Slow keys accessibility feature is managed for {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.universalaccess
    - name: slowKey
    - value: {{ user.macos.textinput.slow_keys | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
