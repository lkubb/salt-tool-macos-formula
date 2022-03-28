{#-
    Resets autocapitalization system-wide to defaults (enabled).
    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.keyboard.autocapitalization', 'defined') %}

Autocapitalization is managed for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticCapitalizationEnabled  # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
