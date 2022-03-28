{#-
    Customizes behavior when closing a window with unconfirmed changes.

    Values:
        - bool [default: false = save silently and close]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.confirm_on_close', 'defined') %}

Behavior when closing a window with unconfirmed changes is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSCloseAlwaysConfirmsChanges # in Apple Global Domain. weird naming, does the opposite of what it says?
    - value: {{ user.macos.behavior.confirm_on_close | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
