{#-
    Customizes Photos hotplug behavior.

    Mind that the actual setting is called "disable...". For consistency,
    the pillar value is inverted. pillar False => disabled True

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.photos_hotplug', 'defined') %}

Photos hotplug behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.ImageCapture
    - name: disableHotPlug
    - value: {{ False == user.macos.behavior.photos_hotplug }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
