# vim: ft=sls

{#-
    Customizes Photos hotplug behavior (open Photos.app when media is inserted,
    might apply to plugging in iPhone as well).

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.behavior", "defined") | selectattr("macos.behavior.photos_hotplug", "defined") %}

Photos hotplug behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - domain: com.apple.ImageCapture
    - name: disableHotPlug
    {#- Mind that the actual setting is called "disable...". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ user.macos.behavior.photos_hotplug is false }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
