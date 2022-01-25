{#-
    Resets default app resume behavior with previously open windows to default (reopen).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.resume_app', 'defined') %}

Default app resume behavior for previously open windows is reset to default (reopen) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSQuitAlwaysKeepsWindows # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
