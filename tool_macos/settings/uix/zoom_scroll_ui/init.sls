# vim: ft=sls

{#-
    Customizes activation status of UI zoom by modifier + scrolling feature.

    .. note::

        Mind that setting this needs Full Disk Access on your terminal emulator application.

    Values:
        - bool [default: false]
        - or mapping

          * enabled: bool [default: false]

          * follow_keyboard_focus: string [default: never]
            - always
            - never
            - when_typing

          * zoom_mode: string [default: full]

            - full
            - split
            - in_picture

          * modifier: string [default: ctrl]

            - ctrl
            - opt
            - cmd
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr("macos.uix", "defined") | selectattr("macos.uix.zoom_scroll_ui", "defined") %}
{%-   from tpldir ~ "/map.jinja" import user_settings with context %}

Zoom UI by scrolling with modifier key feature is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.universalaccess
    - names:
        - closeViewScrollWheelToggle:
            - value: {{ user_settings.enabled }}
            - vtype: bool
        - closeViewZoomMode:
            - value: {{ user_settings.zoom_mode }}
            - vtype: int
        - closeViewScrollWheelModifiersInt:
            - value: {{ user_settings.modifier }}
            - vtype: int
        - closeViewZoomFocusFollowModeKey:
            - value: {{ user_settings.follow_keyboard_focus }}
            - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}
