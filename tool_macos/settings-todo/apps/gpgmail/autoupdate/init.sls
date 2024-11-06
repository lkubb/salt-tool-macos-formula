# vim: ft=sls

Apple Mail automatically checks for updates to GPGMail:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: SUEnableAutomaticChecks
    - value: True
    - vtype: bool
    - user: {{ user.name }}
