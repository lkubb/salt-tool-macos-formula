{#-
    Customizes whether to automatically resend outgoing messages when the server
    was not available (does not warn about failed sends).

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - bool [default: true?]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.auto_resend_later', 'defined') %}

Automatically resend outgoing mail setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: SuppressDeliveryFailure
    - value: {{ user.macos.mail.auto_resend_later | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
