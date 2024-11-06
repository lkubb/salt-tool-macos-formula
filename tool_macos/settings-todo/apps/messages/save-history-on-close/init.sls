# vim: ft=sls

Messages saves history when conversations are closed:
  macdefaults.write:
    - domain: com.apple.iChat
    - name: SaveConversationsOnClose
    - value: true
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
