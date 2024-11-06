# vim: ft=sls

Safari will autocorrect:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebAutomaticSpellingCorrectionEnabled
    - value: True
    - vtype: bool
    - user: {{ user.name }}
