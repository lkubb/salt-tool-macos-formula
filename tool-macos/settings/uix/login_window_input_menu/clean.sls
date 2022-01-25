{#-
    Resets visibility of language picker in boot screen to default.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.uix is defined and macos.uix.login_window_input_menu is defined %}

Visibility of language selection menu in login window is reset to default:
  macosdefaults.absent:
    - domain: /Library/Preferences/com.apple.loginwindow
    - name: showInputMenu
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
