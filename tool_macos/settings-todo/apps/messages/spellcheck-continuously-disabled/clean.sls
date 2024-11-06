# vim: ft=sls

Messages does continuous spell-checking:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: true
    - vtype: dict-add continuousSpellCheckingEnabled -bool
    - user: {{ user.name }}
