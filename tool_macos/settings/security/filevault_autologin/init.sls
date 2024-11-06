# vim: ft=sls

{#-
    Customizes automatic login of FileVault authenticated user.

    Values: bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.filevault_autologin is defined %}

Automatic login of FileVault authenticated user is managed:
  macosdefaults.write:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.loginwindow
    - name: DisableFDEAutoLogin
    {#- Mind that the actual setting is called "Disable...". For consistency,
    the pillar value is inverted. pillar False => disabled True #}
    - value: {{ False == macos.security.filevault_autologin | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
