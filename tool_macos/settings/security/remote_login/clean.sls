# vim: ft=sls

{#-
    Resets activation state of Remote Login (SSH server) to default (disabled).
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.remote_login is defined %}

Activation state of Remote Login (SSH Server) is reset to default (disabled):
  cmd.run:
    - name: launchctl unload -w /System/Library/LaunchDaemons/ssh.plist
    - runas: root
    - require:
      - System Preferences is not running
    - unless:
        - "/usr/sbin/systemsetup getremotelogin | grep 'Remote Login: Off'"
{%- endif %}
