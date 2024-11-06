# vim: ft=sls
# This works from 10.9 - 10.14 (Mavericks to Mojave)
# Opt + click on Scaled to show

Enable HiDPI mode for non-retina displays – requires restart:
  macdefaults.write:
    - domain: /Library/Preferences/com.apple.windowserver
    - name: DisplayResolutionEnabled
    - value: True
    - vtype: bool
    - user: root
