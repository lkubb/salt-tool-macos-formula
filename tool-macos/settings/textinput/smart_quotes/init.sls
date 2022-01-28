{#-
    Customizes activation of smart quotes.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.textinput', 'defined') | selectattr('macos.textinput.smart_quotes', 'defined') %}

Activation of smart quotes is managed for {{ user.name }}:
  macosdefaults.write:
    - name: NSAutomaticQuoteSubstitutionEnabled
    - value: {{ user.macos.textinput.smart_quotes | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
