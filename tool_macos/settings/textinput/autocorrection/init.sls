{#-
    Customizes global autocorrection configuration.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.autocorrection', 'defined') %}

Auotcorect is maganed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSAutomaticSpellingCorrectionEnabled  # in NSGlobalDomain
    - value: {{ user.macos.textinput.autocorrection | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
