{#-
    Resets MacOS window resize time to default (0.5?).
    Might take a reboot to apply.
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.window_resize_time', 'defined') %}

MacOS window resize time is reset to default for user {{ user.name }}:
  macosdefaults.absent:
    - name: NSWindowResizeTime # in NSGlobalDomain
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
