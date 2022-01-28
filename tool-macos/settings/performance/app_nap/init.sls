{#-
    Customizes global app nap behavior.

    .. warning::

        This can be set per application (better).
        It is included for documentary purposes primarily.

    .. note::

        You might need to reboot to apply the settings.

    Values:
        - bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.performance', 'defined') | selectattr('macos.performance.app_nap', 'defined') %}

Global app nap behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: NSAppSleepDisabled # global in NSGlobalDomain. as with most of those, can be set per app
    {#- Mind that the setting is called "...Disabled", so the pillar value is inverted
    for consistency's sake. #}
    - value: {{ False == user.macos.performance.app_nap | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
