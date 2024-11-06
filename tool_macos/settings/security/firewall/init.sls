# vim: ft=sls

{#-
    Customizes state of inbuilt application firewall (blocks incoming connections only).

    Values:
        - dict

          * apple_signed_ok: bool [default: true]
          * download_signed_ok: bool [default: false]
          * enabled: bool [default: true]
          * incoming_block: bool [default: false]
          * logging: bool [default: true]
          * stealth: bool [default: false]

    .. hint::

        stealth mode: ignore ICMP ping or TCP/UDP connection attempts to closed ports
#}

{#- This could also be set like this:

    /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned on/off
    /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp on/off
    /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on/off
    /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on/off
    /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on/off
    /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on/off
    pkill -HUP socketfilterfw
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.firewall is defined %}
{%-   set m = macos.security.firewall %}

State of inbuilt application firewall is managed:
  macosdefaults.write:
    - domain: /Library/Preferences/com.apple.alf
    - names:
{%-   if m.apple_signed_ok is defined %}
        - allowsignedenabled:
            - value: {{ m.apple_signed_ok | int }}
{%-   endif %}
{%-   if m.download_signed_ok is defined %}
        - allowdownloadsignedenabled:
            - value: {{ m.download_signed_ok | int }}
{%-   endif %}
{%-   if m.enabled is defined or m.incoming_block is defined %}
        - globalstate:
            - value: {{ 2 if m.incoming_block else m.enabled | int }}
{%-   endif %}
{%-   if m.logging is defined %}
        - loggingenabled:
            - value: {{ m.logging | int }}
{%-   endif %}
{%-   if m.stealth is defined %}
        - stealthenabled:
            - value: {{ m.stealth | int }}
{%-   endif %}
    - vtype: int
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - socketfilterfw was reloaded
{%- endif %}

