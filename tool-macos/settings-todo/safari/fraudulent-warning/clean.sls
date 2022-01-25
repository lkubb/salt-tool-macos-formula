Safari does not warn about fraudulent websites:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WarnAboutFraudulentWebsites
    - value: False
    - vtype: bool
    - user: {{ user.name }}
