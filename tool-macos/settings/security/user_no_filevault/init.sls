{#-
    Removes FileVault unlock privileges from an account.

    .. note::

        The reverse is interactive::

            `sudo fdesetup add -usertoadd username`

        Handy for e.g. complex FileVault password that's different from your usual account.

    Values:
        - bool [default: false]

    References:
        * https://support.apple.com/en-gb/HT203998
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.security', 'defined')
                            | selectattr('macos.security.user_filevault', 'defined')
                            | selectattr('macos.security.user_filevault') %}

User account {{ user.name }} cannot unlock FileVault volume:
  cmd.run:
    - name: fdesetup remove -user {{ user.name }}
    - runas: root
    - require:
      - System Preferences is not running
{%- endfor %}
