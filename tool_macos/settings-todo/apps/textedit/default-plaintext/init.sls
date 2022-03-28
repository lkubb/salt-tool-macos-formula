TextEdit defaults to plaintext instead of richtext:
  macdefaults.write:
    - domain: com.apple.TextEdit
    - name: RichText
    - value: False
    - vtype: bool
    - user: {{ user.name }}
