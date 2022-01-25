{#-
    Customizes disk image integrity verification behavior.
    Values: bool [default: true]

    Mind that the actual setting is called "Skip...". For consistency,
    the pillar value is inverted. pillar False => disabled True
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.finder', 'defined') | selectattr('macos.finder.dmg_verify', 'defined') %}

Disk image integrity verification behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.frameworks.diskimages
    - names:
      - skip-verify
      - skip-verify-locked
      - skip-verify-remote
    - value: {{ False == user.macos.finder.dmg_verify | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded # unsure
{%- endfor %}
