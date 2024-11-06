# vim: ft=sls

{#-
    Customizes resistance and haptic feedback strength for clicks.

    Values:
        - string [default: medium]

          * low
          * medium
          * high
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- set options = {
      "low": 0,
      "medium": 1,
      "high": 2,
} %}

{%- for user in macos.users | selectattr("macos.touch", "defined") | selectattr("macos.touch.haptic_resistance_click", "defined") %}

Click haptics are managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.AppleMultitouchTrackpad
    - names:
        - FirstClickThreshold
        - SecondClickThreshold
    - value: {{ options.get(user.macos.touch.haptic_resistance_click, 1) }}
    - vtype: int
    - user: {{ user.name }}
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endfor %}

