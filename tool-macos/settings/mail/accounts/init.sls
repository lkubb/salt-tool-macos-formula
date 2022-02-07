{#-
    Allows to configure mail accounts for Apple Mail.

    .. note::

        This will install a configuration profile interactively. The user
        has to accept the installation manually.
        Full Disk Access on your terminal emulator application is not required.

    Values:
        - list of dicts

            * address: string
            * description: string [default: <address>]
            * name: string [default: <username part of address>]
            * type: string [imap, pop. default: imap]
            * server_in:

                - auth: string [default: password]

                    * none
                    * password
                    * crammd5
                    * ntlm
                    * httpmd5

                - domain: string
                - port: int [default: 993]
                - ssl: bool [default: true]
                - username: string [default: <address>]

            * server_out:

                - auth: string [default: password]
                - domain: string
                - port: int [default: 465]
                - ssl: bool [default: true]
                - username: string [default: <address>]
                - password_sameas_in: bool [default: true]

    Example:

    .. code-block:: yaml

        accounts:
          - address: elliotalderson@protonmail.ch
            description: dox
            name: Elliot
            server_in:
              domain: 127.0.0.1
              port: 1143
            server_out:
              domain: 127.0.0.1
              port: 1025
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.mail', 'defined') | selectattr('macos.mail.accounts', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

Mail accounts are configured for user {{ user.name }}:
  macprofile.installed:
    - name: salt.tool.macos-config.mail
    - description: Mail account configuration managed by Salt state tool-macos.settings.mail.accounts
    - organization: salt.tool
    - removaldisallowed: False
    - ptype: com.apple.mail.managed
    - scope: User
    - content:
  {%- for account in user_settings %}
      - {{ account | json }}
  {%- endfor %}
{%- endfor %}
