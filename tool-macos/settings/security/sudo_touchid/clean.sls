{#-
    Resets availability of Touch ID for sudo authentication and
    pam_reattach to default (disabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.security is defined and macos.security.sudo_touchid is defined %}

Availability of Touch ID and pam_reattach for sudo authentication is reset to default:
  file.replace:
    - name: /etc/pam.d/sudo
    - pattern: |
        {{ "#-- managed by tool-macos.settings.security.sudo_touchid --" | regex_escape }}[\w\W]*{{ '#-- end managed zone --' | regex_escape }}
    - repl: ''
    - flags: ['IGNORECASE']
{%- endif %}
