# vim: ft=sls

Messages does not save history when conversations are closed:
  macdefaults.write:
    - domain: com.apple.iChat
    - name: SaveConversationsOnClose
    - value: false
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
