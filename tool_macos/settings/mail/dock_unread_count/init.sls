{#-
    Customizes dock unread messages count of Mail.app.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    .. hint::

        This is implemented as string because in theory, it allows
        to select smart mailboxes etc. (status of 4, set MailDockBadgeMailbox to smartmailbox://<UID>) @TODO?

    Values:
        - string [default: inbox]

            * all
            * inbox
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set options = {
  'inbox': 1,
  'all': 2
  } %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.dock_unread_count', 'defined') %}

Dock unread count of Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: MailDockBadge
    - value: {{ options.get(user.macos.mail.dock_unread_count, 1) | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
