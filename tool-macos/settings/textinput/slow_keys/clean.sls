{#-
    Resets state of slow keys accessibility feature (delay before
    accepting keypresses) to default (disabled).

    Needs Full Disk Access.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.slow_keys', 'defined') %}

Slow keys accessibility feature is reset to default (disabled) for {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.universalaccess
    - name: slowKey
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
