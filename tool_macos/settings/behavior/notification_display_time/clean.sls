{#-
    Resets Notification Center notification display time to default (5s).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.notification_display_time', 'defined') %}

Notification Center notification display time is reset to default (5s) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.notificationcenterui
    - name: bannerTime
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - NotificationCenter was reloaded
{%- endfor %}
