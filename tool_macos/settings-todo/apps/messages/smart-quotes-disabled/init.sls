# vim: ft=sls

Messages does not automatically substitute 'smart' quotes:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: false
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
