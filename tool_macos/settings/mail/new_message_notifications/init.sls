{#-
    Customizes condition to receive new message alerts.

    .. note:

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:

        - string [default: inbox]

            * inbox
            * vips
            * contacts
            * all
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = {
  'inbox': 1,
  'vips': 2,
  'contacts': 3,
  'all': 5} %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.new_message_notifications', 'defined') %}

Condition to receive new message alerts in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: MailUserNotificationScope
    - value: {{ options.get(user.macos.mail.new_message_notifications, 1) | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
