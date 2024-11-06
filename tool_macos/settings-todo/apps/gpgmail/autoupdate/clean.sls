# vim: ft=sls

Apple Mail does not automatically check for updates to GPGMail:
  macdefaults.write:
    - domain: org.gpgtools.gpgmail
    - name: SUEnableAutomaticChecks
    - value: True
    - vtype: bool
    - user: {{ user.name }}
