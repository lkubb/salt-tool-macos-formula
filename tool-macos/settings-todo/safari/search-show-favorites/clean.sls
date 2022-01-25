Safari does not show Favorites below Smart Search results:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: ShowFavoritesUnderSmartSearchField
    - value: False
    - vtype: bool
    - user: {{ user.name }}
