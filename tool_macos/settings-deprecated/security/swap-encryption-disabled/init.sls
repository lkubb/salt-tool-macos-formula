# vim: ft=sls
# this is very likely deprecated, for documentation purposes only
# also this is a bad idea in general

MacOS does not encrypt its swap file (this likely does not work with APFS at least):
  macosdefaults.write:
    - host: current
    - domain: /Library/Preferences/com.apple.virtualMemory
    - name: DisableEncryptedSwap
    - value: True
    - vtype: bool
    - user: root
