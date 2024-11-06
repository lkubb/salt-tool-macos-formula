# vim: ft=sls

{#-
    Resets Time Machine behavior when connecting an
    unknown disk to default (offer as backup target).
    You might need to reboot after applying.
    Mind that setting this needs Full Disk Access on your terminal emulator application.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as macos %}

include:
  - {{ tplroot }}._onchanges
  - {{ tplroot }}._require

{%- if macos.timemachine is defined and macos.timemachine.offer_new_disks is defined %}

Time Machine behavior when connecting an unknown disk is reset to default (offer):
  macosdefaults.absent:
    - domain: /Library/Preferences/com.apple.TimeMachine
    - name: DoNotOfferNewDisksForBackup
    - user: root
    - require:
      - System Preferences is not running
    - watch_in:
      - cfprefsd was reloaded
{%- endif %}
