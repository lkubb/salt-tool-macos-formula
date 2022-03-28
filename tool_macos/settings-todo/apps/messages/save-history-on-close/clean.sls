Messages does not save history when conversations are closed:
  macdefaults.write:
    - domain: com.apple.iChat
    - name: SaveConversationsOnClose
    - value: False
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
