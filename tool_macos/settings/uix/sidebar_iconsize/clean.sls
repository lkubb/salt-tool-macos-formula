{#-
    Resets global prefered sidebar icon size to default (medium).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.sidebar_iconsize', 'defined') %}

Preferred sidebar icon size is reset to default (medium) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSTableViewDefaultSizeMode # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

