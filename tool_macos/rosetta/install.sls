# vim: ft=sls

{#-
    Installs Rosetta on Apple Silicon Macs.

    Note that once installed, removal is very cumbersome and involves
    temporarily deactivating SIP.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

Rosetta is installed:
  cmd.run:
    - name: /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    - unless:
      - pkgutil --pkgs | grep 'com.apple.pkg.RosettaUpdateAuto'
