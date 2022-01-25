{#-
    Resets automatic login to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.autologin is defined %}
  {%- set m = macos.security.autologin %}

Automatic login is set to default (disabled):
  macosdefaults.absent:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.loginwindow
    - name: autoLoginUser
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
