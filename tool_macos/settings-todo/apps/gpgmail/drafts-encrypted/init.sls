# vim: ft=sls

GPGMail 2 encrypts saved drafts:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: OptionallyEncryptDrafts
    - value: True
    - vtype: bool
    - user: {{ user.name }}
