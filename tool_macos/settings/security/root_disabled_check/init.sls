# vim: ft=sls

{#-
    Checks if the root user is disabled.

    .. hint::

        As an administrator, you can run `/usr/sbin/dsenableroot` to enable
        and `/usr/sbin/dsenableroot -d` to disable. The process is interactive.

    Values:
        - bool [default: false]

    References:
        * https://unix.stackexchange.com/questions/232491/how-to-test-if-root-user-is-enabled-in-mac
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- if macos.security is defined and macos.security.root_disabled_check is defined and macos.security.root_disabled_check %}

Check if root user account is disabled:
  test.fail_without_changes:
    - name: Root user account is disabled.
    - unless:
      - >
          test "$(dscl localhost -read /Local/Default/Users/root passwd
          | sed 's/dsAttrTypeNative:passwd: //')" = "*"
    - runas: root
{%- endif %}
