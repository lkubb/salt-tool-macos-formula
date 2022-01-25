{#-
    Customizes new Finder window default path.

    Values: string [default: recent]
        [computer / volume / home / desktop / documents / recent / </my/custom/path>]

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.home', 'defined') %}
  {%- from tpldir ~ '/map.jinja' import user_settings with context %}

New Finder window default path is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.finder
    - names:
  {%- for key, value in user_settings.items() %}
        - {{ key }}:
            - value: {{ value }}
  {%- endfor %}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
