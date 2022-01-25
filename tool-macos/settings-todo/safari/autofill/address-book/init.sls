Safari autofills from Address Book:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillFromAddressBook
    - value: True
    - vtype: bool
    - user: {{ user.name }}
