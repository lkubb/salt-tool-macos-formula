# vim: ft=sls

{#-
    Customizes activation state of Remote Login (SSH server).

    .. note::

        This used to be settable with systemsetup -setremotelogin,
        but that requires Full Disk Access now. Currently, a workaround
        is to manually load/unload the plist with launchctl.

    Values:
        - bool [default: false]

    References:
        * https://www.alansiu.net/2020/09/02/scripting-ssh-off-on-without-needing-a-pppc-tcc-profile/
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.remote_login is defined %}
{%- set m = macos.security.remote_login %}

Activation state of Remote Login (SSH Server) is managed:
  cmd.run:
    - name: launchctl {{ "un" if not m }}load -w /System/Library/LaunchDaemons/ssh.plist
    - runas: root
    - require:
      - System Preferences is not running
    - unless:
        - /usr/sbin/systemsetup getremotelogin | grep 'Remote Login: {{ "On" if m else "Off" }}'
{%- endif %}
