{#-
    Resets activation of cupsd to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.cupsd is defined %}

Activation of cupsd is reset to default (enabled):
  cmd.run:
    - name: /bin/launchctl load -w /System/Library/LaunchDaemons/org.cups.cupsd.plist
    - runas: root
    - unless:
        - /bin/launchctl list | grep 'org.cups.cupsd'
    - require:
      - System Preferences is not running
{%- endif %}
