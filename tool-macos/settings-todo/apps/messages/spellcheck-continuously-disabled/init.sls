Messages does no continuous spell-checking:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: False
    - vtype: dict-add continuousSpellCheckingEnabled -bool
    - user: {{ user.name }}
