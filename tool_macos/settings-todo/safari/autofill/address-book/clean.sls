Safari does not autofill from Address Book:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillFromAddressBook
    - value: False
    - vtype: bool
    - user: {{ user.name }}
