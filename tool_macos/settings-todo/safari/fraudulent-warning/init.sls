# vim: ft=sls

Safari warns about fraudulent websites:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WarnAboutFraudulentWebsites
    - value: True
    - vtype: bool
    - user: {{ user.name }}
