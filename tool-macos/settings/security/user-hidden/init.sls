{#-
    Manages visibility of user accounts.

    .. hint::

        When turned on, this does three things:
            1) Hides the user account from the login window (not FileVault necessarily).
            2) Hides the home folder.
            3) Hides the public share folder.

        Handy for e.g. complex FileVault password that's different from your usual account
        (in combination with user_no_filevault).

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

{%- for user in macos.users | selectattr('macos.security', 'defined') | selectattr('macos.security.user_hidden', 'defined') %}
  {%- set u = user.macos.security.user_hidden %}

Visibility of user account {{ user.name }} is managed:
  cmd.run:
    - name: |
        dscl . create /Users/{{ user.name }} IsHidden {{ u | to_bool | int }}
        chflags {{ 'no' if not u }}hidden /Users/{{ user.name }}
  {%- if u %}
  {#- don't know how to reverse this #}
        dscl . delete "/SharePoints/{{ salt['user.info'](user.name).fullname }}'s Public Folder"
  {%- endif %}
    - require:
      - System Preferences is not running
{%- endfor %}
