# vim: ft=sls

{#-
    Customizes hostname.

    Values:
        - string
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.localization is defined and macos.localization.hostname is defined %}

ComputerName is managed:
  cmd.run:
    - name: /usr/sbin/scutil --set ComputerName "{{ macos.localization.hostname }}"
    - runas: root
    - require:
        - System Preferences is not running
    - unless:
        - test "$(/usr/sbin/scutil --get ComputerName)" = "{{ macos.localization.hostname }}"

HostName is managed:
  cmd.run:
    - name: /usr/sbin/scutil --set HostName "{{ macos.localization.hostname }}"
    - runas: root
    - require:
        - System Preferences is not running
    - unless:
        - test "$(/usr/sbin/scutil --get HostName)" = "{{ macos.localization.hostname }}"

LocalHostName is managed:
  cmd.run:
    - name: /usr/sbin/scutil --set LocalHostName "{{ macos.localization.hostname }}"
    - runas: root
    - require:
        - System Preferences is not running
    - unless:
        - test "$(/usr/sbin/scutil --get LocalHostName)" = "{{ macos.localization.hostname }}"
{%- endif %}
