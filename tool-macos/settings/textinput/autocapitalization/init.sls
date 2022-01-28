{#-
    Customizes autocapitalization system-wide.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.dock', 'defined') | selectattr('macos.keyboard.autocapitalization', 'defined') %}

Autocapitalization is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSAutomaticCapitalizationEnabled  # in NSGlobalDomain
    - value: {{ user.macos.keyboard.autocapitalization | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
