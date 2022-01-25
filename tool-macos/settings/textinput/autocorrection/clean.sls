{#-
    Resets global autocorrection configuration to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.autocorrection', 'defined') %}

Autocorrect is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticSpellingCorrectionEnabled  # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
