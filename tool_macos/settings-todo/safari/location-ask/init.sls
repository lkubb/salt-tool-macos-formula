# vim: ft=sls

Safari asks daily if a website can access location data:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: SafariGeolocationPermissionPolicy
    - value: 1
    - vtype: int
    - user: {{ user.name }}

# Website use of location services:
# 0: Deny without prompting
# 1: Prompt for each website once each day
# 2: Prompt for each website one time only
# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
