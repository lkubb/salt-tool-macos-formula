# vim: ft=sls

{#-
    Customizes delay and rate of key repeats.
    To make this have an effect, turn press and hold off.

    .. note::

        You might need to reboot after applying.

    Values:
        - dict

          * rate: int [default: ?]
          * delay: int [default: ?]
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.textinput", "defined") | selectattr("macos.textinput.repeat", "defined") %}
{%-   set u = user.macos.textinput.repeat %}

Key repeat behavior is managed for {{ user.name }}:
  macosdefaults.write:
    - names:   # in NSGlobalDomain
{%-   if u.rate is defined %}
        - KeyRepeat:
            - value: {{ u.rate | int }}
            - vtype: int
{%-   endif %}
{%-   if u.delay is defined %}
        - InitialKeyRepeat:
            - value: {{ u.delay | int }}
            - vtype: int
{%-   endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
