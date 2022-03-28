Messages does not automatically substitute emojis/smileys :):
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: False
    - vtype: dict-add automaticEmojiSubstitutionEnablediMessage -bool
    - user: {{ user.name }}
