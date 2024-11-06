# vim: ft=sls

{#-
    Customizes dock autohide behavior.

    Values:
        - dict

          * enabled: bool [default: false]
          * time: float [default: 0.5]
          * delay: float [default: 0.5]

    Example:

    .. code-block:: yaml

        autohide:
          enabled: true
          time: 0.01
          delay: 0.01

    References:
        * https://macos-defaults.com/dock/autohide.html
        * https://macos-defaults.com/dock/autohide-time-modifier.html
        * https://macos-defaults.com/dock/autohide-delay.html
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.dock", "defined") | selectattr("macos.dock.autohide", "defined") %}

Dock autohide behavior is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - names:
{%-   if user.macos.dock.autohide.enabled is defined %}
        - autohide:
          - value: {{ user.macos.dock.autohide.enabled | to_bool }}
          - vtype: bool
{%-   endif %}
{%-   if user.macos.dock.autohide.time is defined %}
        - autohide-time-modifier:
          - value: {{ user.macos.dock.autohide.time | float }}
          - vtype: real
{%-   endif %}
{%-   if user.macos.dock.autohide.delay is defined %}
        - autohide-delay:
          - value: {{ user.macos.dock.autohide.delay | float }}
          - vtype: real
{%-   endif %}
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
