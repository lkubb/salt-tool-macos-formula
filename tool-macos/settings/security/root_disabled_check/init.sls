{#-
    Checks if the root user is disabled.

    As an administrator, you can run `/usr/sbin/dsenableroot` to enable
    and `/usr/sbin/dsenableroot -d` to disable. The process is interactive.

    Values: bool [default: false]

    References:
      https://unix.stackexchange.com/questions/232491/how-to-test-if-root-user-is-enabled-in-mac
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.security is defined and macos.security.root_disabled_check is defined and macos.security.root_disabled_check %}

Check if root user account is disabled:
  cmd.run:
    - name: |
        plutil -p /var/db/dslocal/nodes/Default/users/root.plist | \
        grep -A 1 \"passwd\" | grep '0 => "\*"'
    - runas: root
{%- endif %}
