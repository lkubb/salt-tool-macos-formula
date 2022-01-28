{#-
    Customizes whether to show most recent message on top when viewing conversation.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.conv_most_recent_top', 'defined') %}

Message sorting for conversations in Mail.app setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: ConversationViewSortDescending
    - value: {{ user.macos.mail.conv_most_recent_top | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
