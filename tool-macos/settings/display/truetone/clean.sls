{#-
    Resets TrueTone behavior to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.display', 'defined') | selectattr('macos.display.truetone', 'defined') %}

TrueTone is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent_less:
    - name: CBUser-{{ user.guid }}:CBColorAdaptationEnabled
    - domain: com.apple.CoreBrightness
    # this needs to be run as root since the file is
    # /var/root/Library/Preferences/com.apple.CoreBrightness.plist
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - corebrightnessd was reloaded
{%- endfor %}
