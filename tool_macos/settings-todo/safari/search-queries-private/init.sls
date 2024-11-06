# vim: ft=sls

Safari does not send search queries to Apple:
  macdefaults.write:
    - domain: com.apple.Safari
    - names:
      - UniversalSearchEnabled:
        - value: False
      - SuppressSearchSuggestions:
        - value: True
    - vtype: bool
    - user: {{ user.name }}
