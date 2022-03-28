# probably deprecated: https://apple.stackexchange.com/questions/380365/plain-text-e-mails-in-dark-mode-mail-12
Apple Mail prefers plaintext:
  macdefaults.write:
    - domain: com.apple.mail
    - names:
      - PreferPlainText:
        - value: True
      - PreferRichText:
        - value: False
    - vtype: bool
    - user: {{ user.name }}
