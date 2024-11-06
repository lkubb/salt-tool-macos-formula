# vim: ft=sls

Safari does not clear downloads automatically:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: DownloadsClearingPolicy
    - value: 0
    - vtype: int
    - user: {{ user.name }}

# Remove downloads list items
# 0: Manually
# 1: When Safari Quits
# 2: Upon Successful Download
# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
