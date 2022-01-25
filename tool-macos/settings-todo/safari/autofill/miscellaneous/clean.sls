Safari does not autofill miscellaneous forms:
  macdefaults.write:
    - domain: com.apple.Safari
    - name: AutoFillMiscellaneousForms
    - value: False
    - vtype: bool
    - user: {{ user.name }}
