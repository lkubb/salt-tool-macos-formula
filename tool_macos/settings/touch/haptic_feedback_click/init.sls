{#-
    Customizes click feedback (seen in "Silent clicking").

    Values:
        - bool [default: true]

    References:
        * https://github.com/joeyhoer/starter/blob/master/system/trackpad.sh
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- for user in macos.users | selectattr('macos.touch', 'defined') | selectattr('macos.touch.haptic_feedback_click', 'defined') %}

Click feedback (actuation) is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - name: ActuationStrength
    - value: {{ user.macos.touch.haptic_feedback_click | int }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

