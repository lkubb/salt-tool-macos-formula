{#-
    Resets disk image integrity verification behavior to default (enabled).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.dmg_verify', 'defined') %}

Disk image integrity verification behavior is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - domain: com.apple.frameworks.diskimages
    - names:
      - skip-verify
      - skip-verify-locked
      - skip-verify-remote
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
