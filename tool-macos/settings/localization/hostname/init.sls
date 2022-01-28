{#-
    Customizes hostname.

    Values:
        - string
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

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
