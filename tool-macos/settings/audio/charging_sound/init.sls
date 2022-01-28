{#-
    Customizes charging sound (chime) behavior.

    Values:
        - bool [default: true since 10.13/High Sierra]

    .. hint::

        Up until Sierra, this was turned of by default and could be enabled with ChimeOnAllHardware.

    References:
        * https://git.herrbischoff.com/awesome-macos-command-line/about/
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- for user in macos.users | selectattr('macos.audio', 'defined') | selectattr('macos.audio.charging_sound', 'defined') %}

Sound when plugging in charging cable is managed for user {{ user.name }}:
  macosdefaults.write:
    - domain: com.apple.PowerChime
    - name: ChimeOnNoHardware
    - value: {{ user.macos.audio.charging_sound | to_bool }}
    - vtype: bool
    - user: {{ user.name }}
    - require:
      - System Preferences is not running

  {#- if managed user is current console user (logged in), apply instantly #}
  {%- if user.name == macos._console_user %}
PowerChime.app was reloaded for user {{ user.name }}:
  cmd.run:
    - name: |
        if [ "True" = "{{ user.macos.audio.charging_sound }}" ]; then
          open /System/Library/CoreServices/PowerChime.app
        else
          killall PowerChime
        fi
    - runas: {{ user.name }}
    - onchanges:
      - Sound when plugging in charging cable is managed for user {{ user.name }}
  {%- endif %}
{%- endfor %}
