{#-
    Resets hover delay of proxy icons (that can be dragged) in title to default (0.5).

    Note: Before MacOS 11 (Big Sur), there was no delay on hover.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.title_hover_delay', 'defined') %}

Hover delay of proxy icons in title is reset to default (0.5) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSToolbarTitleViewRolloverDelay # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
