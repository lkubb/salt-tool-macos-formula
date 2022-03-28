Safari's bookmark bar is hidden by default:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowFavoritesBar-v2 # seems like this was changed to -v2
    - value: False
    - vtype: bool
    - user: {{ user.name }}
