{#-
    Customizes default app resume behavior when reopening an app that was quit with open windows.

    Values:
      - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.resume_app', 'defined') %}

Default app resume behavior for previously open windows is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSQuitAlwaysKeepsWindows # in NSGlobalDomain
    - value: {{ user.macos.behavior.resume_app | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
