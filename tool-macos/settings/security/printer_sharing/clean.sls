{#-
    Resets state of printer sharing to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.printer_sharing is defined %}

Printer sharing status is reset to default (disabled):
  cmd.run:
    - name: /usr/sbin/cupsctl --no-share-printers
    # this works as non-root user as well, is it not system-wide?
    - runas: root
    # if cupsd is unloaded, cannot manage it
    - onlyif:
        - /bin/launchctl list | grep 'org.cups.cupsd'
    - unless:
        - /usr/sbin/cupsctl | grep '_share_printers=0'
    - require:
      - System Preferences is not running
{%- endif %}
