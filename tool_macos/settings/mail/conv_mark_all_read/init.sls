# vim: ft=sls

{#-
    Customizes whether to mark all messages as read when viewing conversation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.conv_mark_all_read", "defined") %}

Mark all read setting for conversations in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: ConversationViewMarkAllAsRead
    - value: {{ user.macos.mail.conv_mark_all_read | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
