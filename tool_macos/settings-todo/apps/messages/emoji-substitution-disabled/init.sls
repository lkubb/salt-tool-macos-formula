# vim: ft=sls

Messages does not automatically substitute emojis/smileys :):
  macdefaults.write:
    - domain: com.apple.messageshelper.MessageController
    - name: SOInputLineSettings
    - value: false
    - vtype: dict-add automaticEmojiSubstitutionEnablediMessage -bool
    - user: {{ user.name }}
