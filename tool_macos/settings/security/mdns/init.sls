{#-
    Customizes activation status of multicast DNS advertisements.

    .. note::

        The old method described in Awesome MacOS Command Line does not
        work on modern systems with System Integrity Protection.

    References:
      https://git.herrbischoff.com/awesome-macos-command-line/about/#bonjour-service
      https://old.reddit.com/r/macsysadmin/comments/poxv5q/disabling_bonjour_on_bigsur/

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.mdns is defined %}

Activation status of multicast DNS advertisements is managed:
  macosdefaults.write:
    - domain: /Library/Preferences/com.apple.mDNSResponder.plist
    - name: NoMulticastAdvertisements
    {#- Mind that the setting is called "No...", so the pillar value is inverted
    for consistency's sake. #}
    - value: {{ False == macos.security.mdns }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - mDNSResponder was reloaded
{%- endif %}
