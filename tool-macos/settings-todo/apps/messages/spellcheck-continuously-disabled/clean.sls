Messages does continuous spell-checking:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: True
    - vtype: dict-add continuousSpellCheckingEnabled -bool
    - user: {{ user.name }}
