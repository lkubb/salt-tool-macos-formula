{#-
    Resets Siri keyboard shortcut to default (Off / Hold microphone key).
    Needs a logout to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.siri', 'defined') | selectattr('macos.siri.keyboard_shortcut', 'defined') %}

Siri keyboard shortcut is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.Siri
    - name: HotkeyTag
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
