# This works from 10.9 - 10.14 (Mavericks to Mojave)

Disable HiDPI mode for non-retina displays – requires restart:
  macdefaults.absent:
    - domain: /Library/Preferences/com.apple.windowserver
    - name: DisplayResolutionEnabled
    - user: root
