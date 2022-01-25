NotificationCenter was reloaded:
  cmd.wait:
    - name: killall NotificationCenter; killall UserNotificationCenter; exit 0
    - watch: []
    - onlyif_any:
        - pgrep NotificationCenter
        - pgrep UserNotificationCenter
