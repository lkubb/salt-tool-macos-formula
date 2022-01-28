{#-
    Customizes global default action when clicking scrollbar.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.scrollbar_jump_click', 'defined') %}

Action when clicking scrollbar is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleScrollerPagingBehavior # in NSGlobalDomain
    - value: {{ user.macos.uix.scrollbar_jump_click | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
