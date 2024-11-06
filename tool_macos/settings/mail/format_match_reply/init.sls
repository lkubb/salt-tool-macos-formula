# vim: ft=sls

{#-
    Customizes whether to automatically match a mail's format when replying.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.format_match_reply", "defined") %}

Automatically match a mail's format when replying setting in Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: AutoReplyFormat
    - value: {{ user.macos.mail.format_match_reply }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
