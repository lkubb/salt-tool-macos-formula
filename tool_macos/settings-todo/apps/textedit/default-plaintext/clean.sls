# vim: ft=sls

TextEdit defaults to richtext:
  macdefaults.absent:
    - domain: com.apple.TextEdit
    - name: RichText
    - user: {{ user.name }}
