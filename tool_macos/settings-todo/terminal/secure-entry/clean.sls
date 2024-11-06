# vim: ft=sls

Disable Secure Keyboard Entry in Terminal.app:
  macdefaults.write:
    - domain: com.apple.terminal
    - name: SecureKeyboardEntry
    - value: False
    - vtype: bool
    - user: {{ user.name }}
