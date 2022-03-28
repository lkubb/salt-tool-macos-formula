{#-
    Customizes Siri language.

    Values:
        - string [default: maybe depending on system locale? otherwise en-US]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.language', 'defined') %}

Ask Siri language is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.assistant.backedup
    - name: Session Language
    - value: {{ user.macos.siri.language }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
