# vim: ft=sls

{#-
    Customizes Mail.app polling behavior.

    .. note::

        Needs Full Disk Access to work (https://lapcatsoftware.com/articles/containers.html).

    Values:
        - str [default: auto]

          * auto
          * manual

        - or int [minutes between polls]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.mail", "defined") | selectattr("macos.mail.poll", "defined") %}
{%-   from tpldir ~ "/map.jinja" import status with context %}

Polling behavior of Mail.app is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.mail
    - names:
        - AutoFetch:
            - value: {{ status.auto | to_bool }}
            - vtype: bool
        - PollTime:
            - value: {{ status.time | int }}
            - vtype: int
    - user: {{ user.name }}
    - require:
      - Mail.app is not running
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
