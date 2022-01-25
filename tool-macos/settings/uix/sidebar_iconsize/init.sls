{#-
    Customizes global prefered sidebar icon size.
    Values: small / medium / large [default: medium]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- set options = {
  'small': 1,
  'medium': 2,
  'large': 3
  } %}

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.sidebar_iconsize', 'defined') %}

Preferred sidebar icon size is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSTableViewDefaultSizeMode # in NSGlobalDomain
    - value: {{ options.get(user.macos.uix.sidebar_iconsize, 1) }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

