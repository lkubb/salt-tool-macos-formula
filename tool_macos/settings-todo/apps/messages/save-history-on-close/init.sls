Messages saves history when conversations are closed:
  macdefaults.write:
    - domain: com.apple.iChat
    - name: SaveConversationsOnClose
    - value: True
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
