{#-
    Resets behavior when closing a window with unconfirmed changes to default (save silently and close).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.behavior', 'defined') | selectattr('macos.behavior.confirm_on_close', 'defined') %}

Behavior when closing a window with unconfirmed changes is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSCloseAlwaysConfirmsChanges # in Apple Global Domain. weird naming, does the opposite of what it says?
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
