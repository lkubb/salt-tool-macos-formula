Enable Secure Keyboard Entry in Terminal.app:
  macdefaults.write:
    - domain: com.apple.terminal
    - name: SecureKeyboardEntry
    - value: True
    - vtype: bool
    - user: {{ user.name }}
