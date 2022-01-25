{#-
    Resets Internet Sharing status to default (disabled).

    Not sure which service needs restarting, if any.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.internet_sharing is defined %}

Internet Sharing status reset to default (disabled):
  macosdefaults.absent_less:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/SystemConfiguration/com.apple.nat.plist
    - name: NAT:Enabled
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
