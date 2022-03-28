Safari does not spellcheck continuously:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebContinuousSpellCheckingEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
