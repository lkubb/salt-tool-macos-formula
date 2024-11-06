# vim: ft=sls

Messages automatically substitutes emojis/smileys :(:
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: true
    - vtype: dict-add automaticEmojiSubstitutionEnablediMessage -bool
    - user: {{ user.name }}
