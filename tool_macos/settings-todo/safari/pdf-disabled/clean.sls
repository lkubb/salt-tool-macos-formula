Safari displays PDF files:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: WebKitOmitPDFSupport
    - value: False
    - vtype: bool
    - user: {{ user.name }}
