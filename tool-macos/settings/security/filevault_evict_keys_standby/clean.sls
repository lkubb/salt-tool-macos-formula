{#-
    Resets eviction of FileVault keys on standby to defaults (disabled).
    This will also affect some power settings (they will be reset to defaults
    as well).
-#}

{%- set tplroot = tpldir.split('/')[0] -%}
{%- from tplroot ~ "/map.jinja" import macos -%}

{%- if macos.security is defined and macos.security.filevault_evict_keys_standby is defined %}

RAM is powered during sleep:
  pmset.set:
    - name: hibernatemode
    - value: 3 # for laptops, on desktop it's 0

# this might have be needed to avoid crashes when destroying filevault keys on standby for older macs:
#   pmset.set:
#     - value:
#         powernap: 1
#         standby: 1
#         standbydelayhigh: 86400  # surpassed standbydelay in Mojave
#         standbydelaylow: 10800   # surpassed standbydelay in Mojave
#         autopoweroff: 1

FileVault keys are not destroyed when going to hibernate:
  pmset.set:
    - name: destroyfvkeyonstandby
    - value: 0
{%- endif %}
