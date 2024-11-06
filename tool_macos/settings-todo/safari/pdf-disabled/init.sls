# vim: ft=sls

Safari does not display PDF files:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebKitOmitPDFSupport
    - value: True
    - vtype: bool
    - user: {{ user.name }}
