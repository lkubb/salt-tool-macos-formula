{#-
    Resets IPv6 availability on all interfaces to default (automatic).

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.ip6 is defined %}
  {%- set m = macos.security.ip6 %}

IPv6 availability on all interfaces is reset to default (automatic):
  cmd.run:
    - name: |
        /usr/sbin/networksetup -listallnetworkservices | while read i; do \
        SUPPORT=$(networksetup -getinfo "$i" | grep "IPv6: Off") && \
        if [ -n "$SUPPORT" ]; then /usr/sbin/networksetup -setv6automatic "$i"; fi; done;
    - onlyif:
      - |
          /usr/sbin/networksetup -listallnetworkservices | while read i; do \
          SUPPORT=$(networksetup -getinfo "$i" | grep "IPv6: Off") && \
          if [ -n "$SUPPORT" ]; then exit 1; fi; done;
    - require:
      - System Preferences is not running
{%- endif %}
