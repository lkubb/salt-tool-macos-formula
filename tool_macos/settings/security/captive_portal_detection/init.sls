# vim: ft=sls

{#-
    Customizes automatic detection of captive portals.

    .. note::

        You might need to reboot to apply changed settings.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.captive_portal_detection is defined %}

Automatic detection of captive portals is managed:
  macosdefaults.write:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/SystemConfiguration/com.apple.captive.control
    - name: Active
    - value: {{ macos.security.captive_portal_detection | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
