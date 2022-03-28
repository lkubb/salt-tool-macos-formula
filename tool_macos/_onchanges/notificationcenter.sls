NotificationCenter was reloaded:
  cmd.wait:  # noqa: 213
    - name: killall NotificationCenter; killall UserNotificationCenter; exit 0
    - watch: []
    - onlyif_any:
        - pgrep NotificationCenter
        - pgrep UserNotificationCenter
