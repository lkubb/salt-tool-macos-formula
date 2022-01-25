{#-
    Resets NTP synchronization activation status and server
    to default (enabled / time.apple.com).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.ntp is defined %}

  {%- if macos.security.ntp.enabled is defined %}
NTP synchronization activation status is reset to default (enabled):
  cmd.run:
    - name: /usr/sbin/systemsetup -setusingnetworktime on
    - runas: root
    - unless:
        - "/usr/sbin/systemsetup -getusingnetworktime | grep 'Network Time: On'"
    - require:
      - System Preferences is not running
  {%- endif %}

  {%- if macos.security.ntp.server is defined %}
NTP server configuration is reset to default (time.apple.com):
  cmd.run:
    - name: /usr/sbin/systemsetup -setnetworktimeserver time.apple.com
    - runas: root
    - unless:
        - "/usr/sbin/systemsetup -getnetworktimeserver | grep 'time.apple.com'"
    - require:
      - System Preferences is not running
  {%- endif %}
{%- endif %}
