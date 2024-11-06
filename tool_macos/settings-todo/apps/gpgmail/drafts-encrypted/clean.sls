# vim: ft=sls

GPGMail 2 does not encrypt saved drafts:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: OptionallyEncryptDrafts
    - value: False
    - vtype: bool
    - user: {{ user.name }}
