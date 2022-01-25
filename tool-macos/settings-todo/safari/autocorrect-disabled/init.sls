Safari will not autocorrect:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebAutomaticSpellingCorrectionEnabled
    - value: False
    - vtype: bool
    - user: {{ user.name }}
