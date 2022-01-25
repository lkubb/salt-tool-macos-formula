{#-
    Customizes default search scope.
    Values: string [mac, current, previous] [default: mac]

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- set options = {
  'mac': 'SCev',
  'current': 'SCcf',
  'previous': 'SCsp'
  } -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.search_scope_default', 'defined') %}

Finder default search scope is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - name: FXDefaultSearchScope
    - value: {{ options.get(user.macos.finder.search_scope_default, 'mac') }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
