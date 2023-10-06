{#-
    Customizes condition to delete downloaded attachments.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [default: message_deleted]

          * app_quit
          * message_deleted
          * never
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = {
  'app_quit': {'enabled': True, 'hours': 0},
  'message_deleted': {'enabled': True, 'hours': 2147483647},
  'never': {'enabled': False, 'hours': 2147483647},
  } %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.downloads_remove', 'defined') %}

Condition to delete downloaded attachments in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - names:
        - DeleteAttachmentsEnabled:
            - value: {{ options.get(user.macos.mail.downloads_remove, {'enabled': True}).enabled | to_bool }}
            - vtype: bool
        - DeleteAttachmentsAfterHours:
            - value: {{ options.get(user.macos.mail.downloads_remove, {'hours': 2147483647}).hours | int }}
            - vtype: int
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
