{#-
    Resets Siri recording sharing status (will be prompted when enabling).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.privacy', 'defined') | selectattr('macos.privacy.siri_share_recordings', 'defined') %}

Siri recording sharing status is reset to default (unset) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.assistant.support
    - name: Siri Data Sharing Opt-In Status
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded # there is probably more
{%- endfor %}
