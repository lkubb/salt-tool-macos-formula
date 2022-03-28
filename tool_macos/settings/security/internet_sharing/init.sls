{#-
    Customizes Internet Sharing status.

    .. note::

        Not sure which service needs restarting, if any.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.internet_sharing is defined %}

Internet Sharing status is managed:
  macosdefaults.set:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/SystemConfiguration/com.apple.nat.plist
    - name: NAT:Enabled
    - value: {{ macos.security.internet_sharing | to_bool | int }}
    - vtype: int
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
