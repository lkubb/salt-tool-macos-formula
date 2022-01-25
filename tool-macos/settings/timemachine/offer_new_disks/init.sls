{#-
    Customizes Time Machine behavior when connecting an
    unknown disk (default: offer as backup target).

    You might need to reboot after applying.

    Mind that setting this needs Full Disk Access on your terminal emulator application.

    Mind that the setting is called "DoNot...", so the pillar value is inverted.

    Values: bool [default: true]
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

include:
  - {{ tplroot }}.onchanges
  - {{ tplroot }}.require

{%- if macos.timemachine is defined and macos.timemachine.offer_new_disks is defined %}

Time Machine behavior when connecting an unknown disk is managed:
  macosdefaults.write:
    - domain: /Library/Preferences/com.apple.TimeMachine
    - name: DoNotOfferNewDisksForBackup
    - value: {{ False == macos.timemachine.backup_on_battery | to_bool }}
    - vtype: bool
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
