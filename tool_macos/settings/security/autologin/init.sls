{#-
    Customizes automatic login.

    Values:
        - false or string [= username. default: false]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.security is defined and macos.security.autologin is defined %}
  {%- set m = macos.security.autologin %}

Automatic login is managed:
  macosdefaults.{{ 'absent' if not m else 'write' }}:
    # automatic discovery does not work with files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/com.apple.loginwindow
    - name: autoLoginUser
  {%- if m %}
    - value: {{ m }}
    - vtype: string
  {%- endif %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
