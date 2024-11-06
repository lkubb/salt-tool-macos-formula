# vim: ft=sls

{#-
    Allows to **disable** Remote Desktop services.

    .. note::

        Enabling this might not work on MacOS Monterey 12.1 (from CLI) anyways.
        Disabling should work (from CLI).

    Values:
        - bool [default: true]

    References:
        * https://support.apple.com/guide/remote-desktop/enable-remote-management-apd8b1c65bd/mac
        * https://support.apple.com/en-us/HT209161
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.remote_desktop is defined and macos.security.remote_desktop %}

Remote Desktop is disabled:
  cmd.run:
    - name: /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate
    - runas: root
    - require:
      - System Preferences is not running
{%- endif %}
