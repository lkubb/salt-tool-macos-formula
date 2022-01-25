{#-
    Customizes Notification Center notification display time.

    Values: int [seconds, default: 5]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.notification_display_time', 'defined') %}

Notification Center notification display time is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.notificationcenterui
    - name: bannerTime
    - value: {{ user.macos.behavior.notification_display_time | to_bool }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - NotificationCenter was reloaded
{%- endfor %}
