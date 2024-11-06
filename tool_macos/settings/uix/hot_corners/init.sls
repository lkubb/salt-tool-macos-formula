# vim: ft=sls

{#-
    Customizes hot corner settings.

    Values:
        - dict ``<corner>: {action: string, modifier: string}``

          * action:

            - none
            - mission-control
            - app-windows
            - desktop
            - screensaver
            - stop-screensaver
            - displaysleep
            - launchpad
            - notification-center
            - lock-screen
            - quick-note

          * modifier: string

            - none
            - shift
            - ctrl
            - opt
            - cmd

        - corners:

          * top-left
          * top-right
          * bottom-left
          * bottom-right

    Example:

    .. code-block:: yaml

        hot_corners:
          top-left:
            action: displaysleep
            modifier: none
          top-right:
            action: launchpad
            modifier: cmd
          bottom-left:
            action: desktop
            modifier: shift
          bottom-right:
            action: lock-screen
            modifier: opt

#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.hot_corners", "defined") %}
{%-   from tpldir ~ "/map.jinja" import user_settings, corners with context %}

Hot corner configuration is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.dock
    - names:
{%-   for corner in corners %}
        - wvous-{{ "".join(corner.split("_") | map("first")) }}-corner:
            - value: {{ user_settings[corner].action | int }}
        - wvous-{{ "".join(corner.split("_") | map("first")) }}-modifier:
            - value: {{ user_settings[corner].modifier | int }}
{%-   endfor %}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - Dock was reloaded
{%- endfor %}
