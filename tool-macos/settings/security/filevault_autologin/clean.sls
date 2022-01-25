{#-
    Resets automatic login of FileVault authenticated user to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.filevault_autologin is defined %}

Automatic login of FileVault authenticated user is reset to default (enabled):
  macosdefaults.absent:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.loginwindow
    - name: DisableFDEAutoLogin
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
