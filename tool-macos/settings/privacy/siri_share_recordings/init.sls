{#-
    Customizes Siri recording sharing status.

    Values: bool [default: none]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.privacy', 'defined') | selectattr('macos.privacy.siri_share_recordings', 'defined') %}

Siri recording sharing status is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.assistant.support
    - name: Siri Data Sharing Opt-In Status
    - value: {{ 1 if user.macos.privacy.siri_share_recordings else 2 }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
