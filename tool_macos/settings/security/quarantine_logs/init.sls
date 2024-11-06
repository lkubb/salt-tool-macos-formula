# vim: ft=sls

{#-
    Customizes keeping of Quarantine logs.

    .. hint::

        It's a bit surprising the logs are never cleared.

        See for yourself:

        .. code-block:: bash

          echo 'SELECT datetime(LSQuarantineTimeStamp + 978307200, "unixepoch") as LSQuarantineTimeStamp, ' \
            'LSQuarantineAgentName, LSQuarantineOriginURLString, LSQuarantineDataURLString from LSQuarantineEvent;' | \
            sqlite3 /Users/$USER/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2

    Values:
        - dict

          * clear: bool [default: false]
          * enabled: bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.security", "defined") | selectattr("macos.security.quarantine_logs", "defined") %}
{%-   set u = user.macos.security.quarantine_logs %}

{%-   if user.clear is defined and u.clear %}

Quarantine logs are cleared for user {{ user.name }}:
  file.managed:
    - name: {{ user.home }}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
    - contents: ''
{%-   endif %}

{%-   if u.enabled is defined %}

Quarantine log file writable status is managed:
  cmd.run:
    - name: chflags {{ "no" if u.enabled }}schg {{ user.home }}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
    - user: root # since we make it super-user-writable only, we need root
    - {{ 'onlyif' if u.enabled else 'unless' }}:
        - ls -lO '{{ user.home }}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2' | grep 'schg'
        # this test is a bit dumb @TODO
{%-   endif %}
{%- endfor %}
