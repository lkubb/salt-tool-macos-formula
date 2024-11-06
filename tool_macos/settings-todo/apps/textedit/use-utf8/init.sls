# vim: ft=sls

TextEdit defaults to opening files as UTF-8:
  macdefaults.write:
    - domain: com.apple.TextEdit
    - name: PlainTextEncoding
    - value: 4
    - vtype: int
    - user: {{ user.name }}

TextEdit defaults to writing files as UTF-8:
  macdefaults.write:
    - domain: com.apple.TextEdit
    - name: PlainTextEncodingForWrite
    - value: 4
    - vtype: int
    - user: {{ user.name }}
