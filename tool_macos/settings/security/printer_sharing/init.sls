{#-
    Customizes state of printer sharing.

    Values:
        - bool [default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.printer_sharing is defined %}
  {%- set m = macos.security.printer_sharing %}

Printer sharing status is managed:
  cmd.run:
    - name: /usr/sbin/cupsctl --{{ 'no-' if not m }}share-printers
    # this works as non-root user as well, is it not system-wide?
    - runas: root
    # if cupsd is unloaded, cannot manage it
    - onlyif:
        - /bin/launchctl list | grep 'org.cups.cupsd'
    - unless:
        - /usr/sbin/cupsctl | grep '_share_printers={{ 1 if m else 0 }}'
    - require:
      - System Preferences is not running
{%- endif %}
