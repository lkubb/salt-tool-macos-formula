GPGMail 2 does not sign mails by default:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: SignNewEmailsByDefault
    - value: False
    - vtype: bool
    - user: {{ user.name }}
