{#-
    Customizes IPv6 availability on all interfaces.

    .. note::

        This is for documentation mostly. Debatable if sensible.

    Values:
        - bool [default: true]

    References:
        * https://github.com/SummitRoute/osxlockdown/blob/master/commands.yaml
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.ip6 is defined %}
  {%- set m = macos.security.ip6 %}

IPv6 availability on all interfaces is managed:
  cmd.run:
    - name: |
        /usr/sbin/networksetup -listallnetworkservices | while read i; do \
        SUPPORT=$(networksetup -getinfo "$i" | grep "IPv6: {{ 'Off' if m else 'Automatic' }}") && \
        if [ -n "$SUPPORT" ]; then /usr/sbin/networksetup -setv6{{ 'automatic' if m else 'off' }} "$i"; fi; done;
    - onlyif:
      - |
          /usr/sbin/networksetup -listallnetworkservices | while read i; do \
          SUPPORT=$(networksetup -getinfo "$i" | grep "IPv6: {{ 'Off' if m else 'Automatic' }}") && \
          if [ -n "$SUPPORT" ]; then exit 1; fi; done;
    - require:
      - System Preferences is not running
{%- endif %}
