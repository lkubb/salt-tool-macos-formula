GPGMail 2 encrypts mails if receiver's key is present:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: EncryptNewEmailsByDefault
    - value: True
    - vtype: bool
    - user: {{ user.name }}
