{#-
    Resets desktop icon settings to defaults.

    References:
      https://github.com/joeyhoer/starter/blob/master/apps/finder.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.desktop_icons', 'defined') %}
  {%- if user.macos.finder.desktop_icons.show is defined %}

Desktop icon visibility is set to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: CreateDesktop
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
  {%- endif %}

  {%- if user.macos.finder.desktop_icons.keys() - 'show' | list %}

Desktop icon settings are reset to defaults for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: DesktopViewSettings
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded

Desktop icon settings cached in ~/Desktop/.DS_Store were flushed for user {{ user.name }}:
  file.absent:
    - name: {{ user.home }}/Desktop/.DS_Store
    - onchanges:
      - Desktop icon settings are reset to defaults for user {{ user.name }}
  {%- endif %}
{%- endfor %}
