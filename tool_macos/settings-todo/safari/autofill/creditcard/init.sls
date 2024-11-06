# vim: ft=sls

Safari autofills credit card data:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillCreditCardData
    - value: True
    - vtype: bool
    - user: {{ user.name }}
