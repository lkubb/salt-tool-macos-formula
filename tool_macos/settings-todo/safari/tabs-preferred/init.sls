# vim: ft=sls

Safari opens sites in new tabs instead of new windows:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: TabCreationPolicy
    - value: 1
    - vtype: int
    - user: {{ user.name }}

# Open pages in tabs instead of windows:
# 0: Never
# 1: Automatically
# 2: Always
# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
