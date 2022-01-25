{#-
    Resets Finder spring loading behavior to default (enabled, delay 0.5).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.spring_loading', 'defined') %}

Finder spring loading behavior is reset to default (enabled, delay 0.5) for user {{ user.name }}:
  macosdefaults.absent:
    - names:
{%- if user.macos.finder.spring_loading.enabled is defined %}
        - com.apple.springing.enabled # in NSGlobalDomain
{%- endif %}
{%- if user.macos.finder.spring_loading.delay is defined %}
        - com.apple.springing.delay # in NSGlobalDomain
{%- endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
