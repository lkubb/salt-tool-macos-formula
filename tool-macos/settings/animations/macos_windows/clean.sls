{#-
    Resets MacOS window animation activation status to default (enabled).
    This might need a reboot to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.macos_windows', 'defined') %}

MacOS window animation activation status is reset to default (enabled) for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSAutomaticWindowAnimationsEnabled # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
      - Dock was reloaded
{%- endfor %}
