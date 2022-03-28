Messages automatically substitutes emojis/smileys :(:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: True
    - vtype: dict-add automaticEmojiSubstitutionEnablediMessage -bool
    - user: {{ user.name }}
