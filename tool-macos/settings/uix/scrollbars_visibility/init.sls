{#-
    Customizes when scrollbars are visible.

    Values:
        - str [default: automatic]]

            * always
            * automatic
            * when_scrolling
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- set options = {
  'always': 'Always',
  'automatic': 'Automatic',
  'when_scrolling': 'WhenScrolling'
  } %}

{%- for user in macos.users | selectattr('macos.uix', 'defined') | selectattr('macos.uix.scrollbars_visibility', 'defined') %}

Scrollbars visibility setting is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: AppleShowScrollBars # in NSGlobalDomain
    - value: {{ options.get(user.macos.uix.scrollbars_visibility, 'Automatic') }}
    - vtype: string
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
