# vim: ft=sls

{#-
    Resets state of inbuilt application firewall to defaults.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.firewall is defined %}
{%-   set m = macos.security.firewall %}

State of inbuilt application firewall is reset to defaults:
  macosdefaults.absent:
    - domain: /Library/Preferences/com.apple.alf
    - names:
{%-   if m.apple_signed_ok is defined %}
        - allowsignedenabled
{%-   endif %}
{%-   if m.download_signed_ok is defined %}
        - allowdownloadsignedenabled
{%-   endif %}
{%-   if m.enabled is defined or m.incoming_block is defined %}
        - globalstate
{%-   endif %}
{%-   if m.logging is defined %}
        - loggingenabled
{%-   endif %}
{%-   if m.stealth is defined %}
        - stealthenabled
{%-   endif %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - socketfilterfw was reloaded
{%- endif %}
