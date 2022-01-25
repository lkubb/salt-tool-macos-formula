{#-
    Customizes audio device settings. Currently only adds
    default settings for specific devices. @TODO preferred_devices
    management.

    Example:
      - "device.AppleUSBAudioEngine:Native Instruments:Komplete Audio 6 MK2:ABCD1EF2:1,2":
          output.stereo.left: 5
          output.stereo.right: 6

    Values: list of dicts [ {device_uid: { setting: value } } ]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.audio is defined and macos.audio.devices is defined and macos.audio.devices %}

Audio devices are managed:
  macosdefaults.update:
    # automatic discovery does not work files in /Library/Preferences
    # because root preferences are in /var/root/Library/Preferences
    - domain: /Library/Preferences/Audio/com.apple.audio.SystemSettings
    - names:
  {%- for uid, settings in macos.audio.devices.items() %}
        - {{ uid }}:
            - value: {{ settings | json }}
  {%- endfor %}
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
      - coreaudiod was reloaded
{%- endif %}
