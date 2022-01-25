{#-
    Customizes Mail.app new message alert sound.

    Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values: str [default: New Mail]
      [Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse,
        Ping, Pop, Purr, Sosumi, Submarine, Tink]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- set options = ['Basso', 'Blow', 'Bottle', 'Frog', 'Funk', 'Glass', 'Hero', 'Morse',
                   'Ping', 'Pop', 'Purr', 'Sosumi', 'Submarine', 'Tink'] %}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.new_message_sound', 'defined') %}

New message alert sound of Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - name: NewMessagesSoundName
    - value: {{ user.macos.mail.new_message_sound if user.macos.mail.new_message_sound in options else 'New Message' }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
