{#-
    Customizes power settings.

    Values:
        - dict of <scope> => {name: val, othername: otherval} mappings
          where scope is in [all, ac, battery, ups].

    Example:

    ... code-block:: yaml

        power:
          all:
            standby: 1
            destroyfvkeysonstandby: 0
          ac:
            displaysleep: 10
            halfdim: 1
          battery:
            displaysleep: 5
            halfdim: 0
            lessbright: 1

    References:
        * man pmset
        * https://en.wikipedia.org/wiki/Pmset
        * https://apple.stackexchange.com/a/262593
-#}

{#- This could be managed with macosdefaults as well, the files are
        * /Library/Preferences/com.apple.PowerManagement.plist and
        * /Library/Preferences/com.apple.PowerManagement.<UUID>.plist

    or before Sierra 10.12.3:
    /Library/Preferences/SystemConfiguration/com.apple.PowerManagement.plist

    and would need `sudo pmset touch` to be applied.

    file without uuid:
      "AC Power" =     {
          DarkWakeBackgroundTasks = 1;
          "Disk Sleep Timer" = 10;
          "Display Sleep Timer" = 10;
          "System Sleep Timer" = 1;
          "Wake On LAN" = 0;
      };
      "Battery Power" =     {
          DarkWakeBackgroundTasks = 1;
          "Disk Sleep Timer" = 10;
          "Display Sleep Timer" = 2;
          ReduceBrightness = 1;
          "System Sleep Timer" = 1;
      };
      SystemPowerSettings =     {
          DestroyFVKeyOnStandby = 0;
          "Update DarkWakeBG Setting" = 1;
      };

    file with uuid:
      "AC Power" =     {
          "Hibernate File" = "/var/vm/sleepimage";
          "Hibernate Mode" = 3;
          HighPowerMode = 0;
          LowPowerMode = 0;
          PrioritizeNetworkReachabilityOverSleep = 0;
          "Sleep On Power Button" = 1;
          "Standby Enabled" = 1;
          TCPKeepAlivePref = 1;
          TTYSPreventSleep = 1;
      };
      "Battery Power" =     {
          "Hibernate File" = "/var/vm/sleepimage";
          "Hibernate Mode" = 3;
          HighPowerMode = 0;
          LowPowerMode = 0;
          "Sleep On Power Button" = 1;
          "Standby Enabled" = 1;
          TCPKeepAlivePref = 1;
          TTYSPreventSleep = 1;
      };
#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.require

{%- if macos.power is defined %}
  {%- for scope, settings in macos.power.items() %}

Power settings for '{{ scope }}' scope are managed:
  pmset.set:
    - value: {{ settings | json }}
    - scope: {{ scope }}
    - require:
      - System Preferences is not running
  {%- endfor %}
{%- endif %}
