# vim: ft=sls

{#-
    Customizes NightShift behavior.

    Values:
        - dict

          * enabled: bool [default: true]
          * temperature: float [2700-6000, default: 4100]
          * schedule: dict
            - start: HH:mm or HH [default: 22:00]
            - end:   HH:mm or HH [default: 07:00]

    .. note::

        When specifying in HH:mm format, remember quote it, otherwise
        yaml might incite chaos.

    Example:

    .. code-block:: yaml

        nightshift:
          enabled: true
          temperature: 4500
          schedule:
            start: '05:17'
            end:   '13:37'

    References:
        * https://web.archive.org/web/20200316123016/https://github.com/aethys256/notes/blob/master/macOS_defaults.md
        * https://www.reddit.com/r/osx/comments/6334ac/toggling_night_shift_from_script/
        * https://github.com/LukeChannings/dotfiles/blob/main/install.macos#L418-L438
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

# This might need to actually use defaults, not skeleton (?) @FIXME

{%- for user in macos.users | selectattr("macos.display", "defined") | selectattr("macos.display.nightshift", "defined") %}
{%-   from tpldir ~ "/map.jinja" import user_settings with context %}

NightShift is customized for user {{ user.name }}:
  macosdefaults.update:
    - name: CBUser-{{ user.guid }}
    - domain: com.apple.CoreBrightness
    - merge: true # for documentation purposes, this is default
    - value: {{ user_settings | json }}
    - skeleton:
        CBUser-{{ user.guid }}:
          CBBlueLightReductionCCTTargetRaw: 4100.0
          CBBlueReductionStatus:
            AutoBlueReductionEnabled: 1
            BlueLightReductionAlgoOverride: 0
            BlueLightReductionDisableScheduleAlertCounter: 3
            BlueLightReductionSchedule:
              DayStartHour: 7
              DayStartMinute: 0
              NightStartHour: 22
              NightStartMinute: 0
            BlueReductionAvailable: true
            BlueReductionEnabled: 0
            BlueReductionMode: 1
            BlueReductionSunScheduleAllowed: true
            Version: 1
          CBColorAdaptationEnabled: 1
    # this needs to be run as root since the file is
    # /var/root/Library/Preferences/com.apple.CoreBrightness.plist
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - corebrightnessd was reloaded
{%- endfor %}
