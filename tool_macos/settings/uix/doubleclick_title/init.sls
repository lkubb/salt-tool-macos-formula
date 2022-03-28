{#-
    Customizes action when doubleclicking a window's title.

    Values:
        - str [default: maximize]

            * none
            * minimize
            * maximize
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set options = ['none', 'minimize', 'maximize'] %}

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.doubleclick_title', 'defined') %}
  {%- set u = user.macos.uix.doubleclick_title %}

Action when doubleclicking a window's title is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleActionOnDoubleClick # in NSGlobalDomain
    - value: {{ u | capitalize if u in options else 'Maximize' }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
