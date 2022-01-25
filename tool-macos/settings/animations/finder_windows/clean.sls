{#-
    Resets Finder window animation activation status to default (enabled).
    This mostly affects the File Info dialog.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.finder_windows', 'defined') %}

Finder window animation activation status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.finder
    - name: DisableAllAnimations
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
{%- endfor %}
