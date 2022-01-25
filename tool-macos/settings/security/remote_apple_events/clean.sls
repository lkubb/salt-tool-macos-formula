{#-
    Resets activation state of Remote Apple Events to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.security is defined and macos.security.remote_apple_events is defined %}

Activation state of Remote Apple Events is reset to default (disabled):
  cmd.run:
    - name: /usr/sbin/systemsetup setremoteappleevents off
    - runas: root
    - unless:
        - "/usr/sbin/systemsetup getremoteappleevents | grep 'Remote Apple Events: Off'"
    - require:
      - System Preferences is not running
{%- endif %}
