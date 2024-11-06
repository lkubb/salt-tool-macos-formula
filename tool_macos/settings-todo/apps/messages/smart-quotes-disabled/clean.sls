# vim: ft=sls

Messages 'smartly' substitutes quotes:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: true
    - vtype: dict-add automaticQuoteSubstitutionEnabled -bool
    - user: {{ user.name }}
