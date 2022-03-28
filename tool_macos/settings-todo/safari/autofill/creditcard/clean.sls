Safari does not autofill credit card data:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillCreditCardData
    - value: False
    - vtype: bool
    - user: {{ user.name }}
