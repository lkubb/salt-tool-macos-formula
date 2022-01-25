{#-
    Customizes global automatic termination of inactive apps behavior.
    This can be set per application (better).
    It is included for documentary purposes primarily.

    Mind that the setting is called "...Disable...", so the pillar value is inverted
    for consistency's sake.

    You might need to reboot to apply the settings.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.performance', 'defined') | selectattr('macos.performance.auto_termination', 'defined') %}

Global autotermination of inactive apps behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSDisableAutomaticTermination # global in NSGlobalDomain. as with most of those, can be set per app
    - value: {{ False == user.macos.performance.auto_termination | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
