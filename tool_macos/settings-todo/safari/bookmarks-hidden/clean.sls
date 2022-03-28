Safari's bookmark bar is shown by default:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowFavoritesBar-v2
    - value: True
    - vtype: bool
    - user: {{ user.name }}
