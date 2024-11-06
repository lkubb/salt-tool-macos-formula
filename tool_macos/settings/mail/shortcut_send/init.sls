# vim: ft=sls

{#-
    Customizes shortcut to send mails.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - string [example: ``@\U21a9`` for Cmd+Enter]

    References:
        * https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html
        * https://web.archive.org/web/20160314030051/http://osxnotes.net/keybindings.html
        * https://github.com/ttscoff/KeyBindings
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.shortcut_send", "defined") %}

Custom shortcut to send mails in Mail.app is managed for user {{ user.name }}:
  macosdefaults.set:
    - domain: com.apple.mail
    - name: NSUserKeyEquivalents:Send
    - value: '{{ user.macos.mail.shortcut_send }}'
    - vtype: string
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
