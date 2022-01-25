{#-
    Resets behavior when all print jobs are finished to default (queue keeps running).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.printqueue_autoquit', 'defined') %}

Behavior when all print jobs are finished is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.print.PrintingPrefs
    - name: Quit When Finished
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
