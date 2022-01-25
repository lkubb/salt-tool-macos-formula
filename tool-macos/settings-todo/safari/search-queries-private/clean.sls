Safari sends search queries to Apple:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - UniversalSearchEnabled:
        - value: True
      - SuppressSearchSuggestions:
        - value: False
    - vtype: bool
    - user: {{ user.name }}
