# vim: ft=sls

GPGMail 2 does not encrypt mails by default:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: EncryptNewEmailsByDefault
    - value: False
    - vtype: bool
    - user: {{ user.name }}
