Safari opens new tabs with homepage:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: NewTabBehavior
    - value: 1
    - vtype: int
    - user: {{ user.name }}

# Setup new window and tab behvior
# 0: Homepage
# 1: Empty Page
# 2: Same Page
# 3: Bookmarks
# 4: Top Sites
# https://github.com/joeyhoer/starter/blob/master/apps/safari.sh
