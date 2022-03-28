{#-
    Customizes whether to display unread messages in bold font.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.unread_bold', 'defined') %}

Display unread messages in bold font setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: ShouldShowUnreadMessagesInBold
    - value: {{ user.macos.mail.unread_bold | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
