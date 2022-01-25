{#-
    Resets keeping of Quarantine logs to defaults.

    Obviously cannot recover cleared logs.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.security', 'defined') | selectattr('macos.security.quarantine_logs', 'defined') %}
  {%- set u = user.macos.security.quarantine_logs %}

  {%- if u.enabled is defined %}
Quarantine log file writable status is reset to default:
  cmd.run:
    - name: chflags noschg {{ user.home }}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2
    - user: root # since we make it super-user-writable only, we need root
    - unless:
        - ls -lO '{{ user.home }}/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV2' | grep 'schg'
  {%- endif %}
{%- endfor %}
