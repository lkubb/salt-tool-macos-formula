{#-
    Customizes behavior when all print jobs are finished.

    Values: bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.printqueue_autoquit', 'defined') %}

Behavior when all print jobs are finished is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.print.PrintingPrefs
    - name: Quit When Finished
    - value: {{ user.macos.behavior.printqueue_autoquit | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
