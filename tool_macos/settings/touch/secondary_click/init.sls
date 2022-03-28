{#-
    Customizes secondary click touch gesture activation status.

    Values:
        - string [default: two]

            * two [fingers]
            * corner-right [bottom]
            * corner-left [bottom]

        - or false
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

{%- set corner_status = {
  'corner-right': {
    'current': 1,
    'others': 2
  },
  'corner-left': {
    'current': 3,
    'others': 1
  },
  'default': {
    'current': 0,
    'others': 0
  }} %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.secondary_click', 'defined') %}
  {%- set user_corners = salt['match.filter_by'](corner_status, minion_id=user.macos.touch.secondary_click) %}

Secondary click activation status is managed for user {{ user.name }}:
  macosdefaults.write:
    - name: ContextMenuGesture # in Apple Global Domain
    - value: {{ user.macos.touch.secondary_click is not sameas False | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on internal trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - TrackpadRightClick:
            - value: {{ 'two' == user.macos.touch.secondary_click }}
            - vtype: bool
        - TrackpadCornerSecondaryClick:
            - value: {{ user_corners.others | int }}
            - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on bluetooth trackpad is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.driver.AppleBluetoothMultitouch.trackpad
    - names:
        - TrackpadRightClick:
            - value: {{ 'two' == user.macos.touch.secondary_click }}
            - vtype: bool
        - TrackpadCornerSecondaryClick:
            - value: {{ user_corners.others | int }}
            - vtype: int
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

Secondary click activation status on current host is managed for user {{ user.name }}:
  macosdefaults.write:
    - host: current
    - names: # in Apple Global Domain
        - com.apple.trackpad.enableSecondaryClick:
            - value: {{ 'two' == user.macos.touch.secondary_click }}
            - vtype: bool
        - com.apple.trackpad.trackpadCornerClickBehavior:
            - value: {{ user_corners.current | int }}
            - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded

{%- endfor %}
