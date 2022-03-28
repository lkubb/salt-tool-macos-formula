{#-
    Customizes display of password hint (number of tries).

    Values:
        - int [0 to disable, default 3?]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.security', 'defined') | selectattr('macos.security.password_hint_after', 'defined') %}

Number of tries before password hint is shown is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: RetriesUntilHint # in NSGlobalDomain
    - value: {{ user.macos.security.password_hint_after | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
