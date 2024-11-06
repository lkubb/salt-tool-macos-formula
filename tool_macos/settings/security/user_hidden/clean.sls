# vim: ft=sls

{#-
    Resets visibility of user account to default (visible).

    Since enabling user_hidden hides the public share folder and
    I don't currently know from the back of my head how to put that
    back in, this folder will stay hidden.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.security", "defined") | selectattr("macos.security.user_hidden", "defined") %}

Visibility of user account {{ user.name }} is reset to default (visible):
  cmd.run:
    - name: |
        dscl . delete /Users/{{ user.name }} IsHidden
        chflags nohidden /Users/{{ user.name }}
    - require:
      - System Preferences is not running
{%- endfor %}
