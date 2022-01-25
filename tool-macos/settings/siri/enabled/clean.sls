{#-
    Resets Siri activation status to default (disabled).
    Note that System Preferences does much more when toggling
    the option. This might be very incomplete.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.enabled', 'defined') %}

Ask Siri activation status is reset to default (disabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.assistant.support
    - name: Assistant Enabled
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
