# vim: ft=sls

{#-
    Customizes activation of press-and-hold behavior for special keys.
    Turn this off to enable faster key repeats.

    .. note::

        You might need to reboot after applying.

    Values:
        - bool [default: true]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.textinput", "defined") | selectattr("macos.textinput.press_and_hold", "defined") %}

Press-and-hold behavior is managed for {{ user.name }}:
  macosdefaults.write:
    - name: ApplePressAndHoldEnabled  # in NSGlobalDomain
    - value: {{ user.macos.textinput.press_and_hold | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
