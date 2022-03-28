{#-
    Customizes NTP synchronization activation status and server.

    Values:
        - dict

            * enabled: bool [default: true]
            * server: string [default: time.apple.com]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.ntp is defined %}
  {%- set m = macos.security.ntp %}

  {%- if m.enabled is defined %}
NTP synchronization activation status is managed:
  cmd.run:
    - name: /usr/sbin/systemsetup -setusingnetworktime {{ 'on' if m else 'off' }}
    - runas: root
    - unless:
        - "/usr/sbin/systemsetup -getusingnetworktime | grep 'Network Time: {{ 'On' if m else 'Off' }}'"
    - require:
      - System Preferences is not running
  {%- endif %}

  {%- if m.server is defined %}
NTP server configuration is managed:
  cmd.run:
    - name: /usr/sbin/systemsetup -setnetworktimeserver {{ m.server }}
    - runas: root
    - unless:
        - "/usr/sbin/systemsetup -getnetworktimeserver | grep '{{ m.server }}'"
    - require:
      - System Preferences is not running
  {%- endif %}
{%- endif %}
