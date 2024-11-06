# vim: ft=sls

TextEdit defaults to plaintext instead of richtext:
  macdefaults.write:
    - domain: com.apple.TextEdit
    - name: RichText
    - value: false
    - vtype: bool
    - user: {{ user.name }}
