{#-
    Customizes MacOS window animation activation status.

    .. note::

        This might need a reboot to apply.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.animations', 'defined') | selectattr('macos.animations.macos_windows', 'defined') %}

MacOS window animation activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSAutomaticWindowAnimationsEnabled # in NSGlobalDomain
    - value: {{ user.macos.animations.macos_windows | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Finder was reloaded
      - Dock was reloaded
{%- endfor %}
