{#-
    Resets Photos hotplug behavior to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.photos_hotplug', 'defined') %}

Photos hotplug behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - host: current
    - domain: com.apple.ImageCapture
    - name: disableHotPlug
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
