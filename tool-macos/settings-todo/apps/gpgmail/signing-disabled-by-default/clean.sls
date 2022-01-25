GPGMail 2 signs mails by default:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: SignNewEmailsByDefault
    - value: True
    - vtype: bool
    - user: {{ user.name }}
